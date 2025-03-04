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

  desc 'update-inventory', 'Update openFPGA cores inventory'
  def update_inventory
    sources = @inventory_service.sources
    sources.each do |source|
      @logger.info("Fetching #{source.repository}")

      repository = @github_service.repository(source.repository)
      funding = funding(source.repository)

      source.contents.each do |path|
        @github_service.commits(source.repository, { path: path }).reverse.each do |commit|
          content = @github_service.contents(source.repository, { path: path, ref: commit.sha })
          next if content.nil?

          update_source(repository, funding, content.download_url)
        end
      end

      next unless source.assets.any?

      @github_service.releases(source.repository).reverse.each do |release|
        source.assets.each do |pattern|
          asset = release.assets.find { |a| a.name.match?(pattern) }
          next if asset.nil?

          update_source(repository, funding, asset.browser_download_url)
        end
      end
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
    archive_path = DownloadHelper.download(url)
    ZipHelper.extract(archive_path)
  end

  def funding(repository)
    content = @github_service.funding(repository)
    return if content.nil?

    funding_path = DownloadHelper.download(content.download_url)
    GitHub::Funding.from_file(funding_path)
  end

  def update_source(repository, funding, download_url)
    openfpga_path = download_archive(download_url)
    openfpga_service = Analogue::OpenFPGAService.new(openfpga_path)
    openfpga_service.cores.each do |core|
      cache = @inventory_service.core(core.id)
      next if !cache.nil? && cache.release_exists?(download_url)

      data = openfpga_service.data(core.id)
      updaters = openfpga_service.updaters(core.id)
      info = openfpga_service.info(core.id)

      inventory_core = cache || Inventory::Core.new(core.id, repository, funding)

      release = Inventory::Release.new(download_url, core, data, updaters, info)
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

        @inventory_service.write_platform(platform_id, platform) if latest_release

        image_path = File.join(@jekyll_service.images_path, PLATFORMS_DIRECTORY, "#{platform_id}.png")
        openfpga_service.export_image(platform_id, image_path)
      end
    end
  rescue StandardError => e
    @logger.error("Failed to update source: #{repository.slug} - #{download_url}")
    @logger.error(e)
  end
end

Updater.start(ARGV)
