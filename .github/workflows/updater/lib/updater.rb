# frozen_string_literal: true

require 'thor'

require_relative 'analogue/openfpga_service'
require_relative 'download_helper'
require_relative 'github/funding'
require_relative 'github/github_service'
require_relative 'github/workflow_logger'
require_relative 'inventory/core'
require_relative 'inventory/release'
require_relative 'inventory/source'
require_relative 'inventory/inventory_service'
require_relative 'jekyll/jekyll_service'
require_relative 'jekyll/post'
require_relative 'zip_helper'

# Service for updating the openFPGA inventory
class Updater < Thor
  AUTHORS_DIRECTORY = 'authors'
  PLATFORMS_DIRECTORY = 'platforms'

  attr_reader :logger, :github_service, :inventory_service, :jekyll_service

  class_option :site_path, type: :string, default: Dir.pwd

  def initialize(args, opts, config)
    super(args, opts, config)

    @logger = GitHub::WorkflowLogger.new($stdout)
    @github_service = GitHub::GitHubService.new
    @jekyll_service = Jekyll::JekyllService.new(options[:site_path])
    @inventory_service = Inventory::InventoryService.new(@jekyll_service.data_path)
  end

  def self.exit_on_failure?
    true
  end

  desc 'update-inventory', 'Update openFPGA Cores Inventory'
  def update_inventory
    sources = @inventory_service.sources
    sources.each do |source|
      @logger.start_group("Processing Source: #{source.repository}")

      repository = @github_service.repository(source.repository)
      funding = funding(source.repository)

      source.contents.each do |path|
        @logger.info("Processing path: #{path}")
        @github_service.commits(source.repository, { path: path }).each do |commit|
          content = @github_service.contents(source.repository, { path: path, ref: commit.sha })
          next if content.nil?

          new_release = update_source(repository, funding, commit.commit.author.date, content.download_url)
          break unless new_release
        end
      end

      unless source.assets.any?
        @logger.end_group
        next
      end

      @github_service.releases(source.repository).each do |release|
        new_release = false
        source.assets.each do |pattern|
          asset = release.assets.find { |a| a.name.match?(pattern) }
          next if asset.nil?

          @logger.info("Processing asset: #{asset.name}")
          new_release ||= update_source(repository, funding, asset.created_at, asset.browser_download_url)
        end

        break unless new_release
      end

      @logger.end_group
    end
  end

  desc 'generate-posts', 'Generate Jekyll posts from openFPGA cores'
  def generate_posts
    @inventory_service.cores.each do |core|
      core.releases.each do |release|
        platform_id = release.core.metadata.platform_ids.first
        platform = @inventory_service.platform(platform_id)

        post = Jekyll::Post.new(
          release.core.metadata.author, # author
          "#{core.id} - #{release.core.metadata.version}", # title
          release.core.metadata.date_release, # date
          [platform.category, platform.name], # categories
          [core.id], # tags
          release.info # content
        )

        @jekyll_service.create_post(core.id, post)
      end
    end
  end

  private

  def download_archive(url)
    @logger.info("Downloading archive: #{url}")
    archive_path = DownloadHelper.download(url)
    ZipHelper.extract(archive_path)
  end

  def funding(repository)
    content = @github_service.funding(repository)
    return if content.nil?

    funding_path = DownloadHelper.download(content.download_url)
    GitHub::Funding.from_file(funding_path)
  end

  def update_source(repository, funding, date, download_url)
    openfpga_path = download_archive(download_url)
    openfpga_service = Analogue::OpenFPGAService.new(openfpga_path)

    new_release = openfpga_service.cores.all? do |core|
      cache = @inventory_service.core(core.id)
      !cache.nil? && !cache.release_exists?(download_url)
    end

    return false unless new_release

    openfpga_service.cores.each do |core|
      cache = @inventory_service.core(core.id)
      next if !cache.nil? && cache.release_exists?(download_url)

      data = openfpga_service.data(core.id)
      updaters = openfpga_service.updaters(core.id)
      info = openfpga_service.info(core.id)

      inventory_core = cache || Inventory::Core.new(core.id, repository, funding)

      release = Inventory::Release.new(date, download_url, core, data, updaters, info)
      inventory_core.add_release(release)

      @inventory_service.write_core(inventory_core)

      # Only update platforms and assets if it's the latest release
      latest_release = release == inventory_core.releases.last
      next unless latest_release

      icon_path = File.join(@jekyll_service.images_path, AUTHORS_DIRECTORY, "#{core.id}.png")
      openfpga_service.export_icon(core.id, icon_path)

      core.metadata.platform_ids.each do |platform_id|
        platform = openfpga_service.platform(platform_id)
        next if platform.nil?

        @inventory_service.write_platform(platform_id, platform)

        image_path = File.join(@jekyll_service.images_path, PLATFORMS_DIRECTORY, "#{platform_id}.png")
        openfpga_service.export_image(platform_id, image_path)
      end
    end

    true
  rescue StandardError => e
    @logger.error("Failed to update source: #{repository.slug} - #{download_url}")
    @logger.error(e)
    true
  end
end

Updater.start(ARGV)
