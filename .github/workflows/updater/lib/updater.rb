# frozen_string_literal: true

require 'thor'
require 'yaml'

require_relative 'updater/analogue'
require_relative 'updater/cache_service'
require_relative 'updater/github'
require_relative 'updater/jekyll'
require_relative 'updater/download_helper'
require_relative 'updater/release'
require_relative 'updater/source_repository'
require_relative 'updater/zip_helper'

# Updater CLI
class Updater < Thor
  AUTHORS_DIRECTORY = 'authors'
  CORES_DIRECTORY = 'cores'
  PLATFORMS_DIRECTORY = 'platforms'
  RELEASES_DIRECTORY = 'releases'

  SOURCES_FILE = 'sources.yml'

  attr_reader :github_service, :jekyll_service, :cache_service, :source_repository

  class_option :site_path, default: Dir.pwd

  def initialize(args, opts, config)
    super(args, opts, config)

    @github_service = GitHub::GitHubService.new
    @jekyll_service = Jekyll::JekyllService.new(options[:site_path])
    @cache_service = CacheService.new(@jekyll_service.data_path)
    @source_repository = SourceRepository.new(File.join(@jekyll_service.data_path, SOURCES_FILE))
  end

  option :force, type: :boolean, default: false
  desc 'update-cores', 'Update openFGPA cores'
  def update_cores
    sources = @source_repository.get_sources
    sources.each do |source|
      download_url = get_download_url(source.repository, source.options)

      core_path = DownloadHelper.download(download_url)
      openfpga_path = ZipHelper.extract(core_path)

      openfpga_service = Analogue::OpenFPGAService.new(openfpga_path)
      openfpga_service.get_cores.each do |core|
        unless options[:force]
          cache = @cache_service.get_core(core.id)
          next if !cache.nil? && cache.metadata.version == core.metadata.version
        end

        write_core(core.id, core)

        platform = openfpga_service.get_platform(core.platform_id)
        write_platform(core.platform_id, platform)

        funding = get_funding(source.repository)

        release = Release.new(download_url, source.repository, funding)
        write_release(core.id, release)

        icon_path = File.join(@jekyll_service.images_path, AUTHORS_DIRECTORY, "#{core.id}.png")
        openfpga_service.export_icon(core.id, icon_path)

        image_path = File.join(@jekyll_service.images_path, PLATFORMS_DIRECTORY, "#{core.platform_id}.png")
        openfpga_service.export_image(core.platform_id, image_path)
      end
    end
  end

  desc 'generate-posts', 'Generate Jekyll posts from openFPGA cores'
  def generate_posts
    @cache_service.get_cores.each do |core|
      platform = @cache_service.get_platform(core.platform_id)
      create_post(core, platform)
    end
  end

  private

  def create_post(core, platform)
    post = Jekyll::Post.new(
      core.metadata.author,
      "#{core.id} - #{core.metadata.version}",
      core.metadata.date_release,
      [platform.category, platform.name],
      [core.id],
      core.info
    )

    @jekyll_service.create_post(core.id, post)
  end

  def write_platform(platform_id, platform)
    path = File.join(@jekyll_service.data_path, PLATFORMS_DIRECTORY, "#{platform_id}.yml")
    File.write(path, platform.to_yaml)
  end

  def write_core(core_id, core)
    path = File.join(@jekyll_service.data_path, CORES_DIRECTORY, "#{core_id}.yml")
    File.write(path, core.to_yaml)
  end

  def write_release(core_id, release)
    path = File.join(@jekyll_service.data_path, RELEASES_DIRECTORY, "#{core_id}.yml")
    File.write(path, release.to_yaml)
  end

  def get_download_url(repository, options)
    path = options[:path]
    if path.nil?
      get_asset_download_url(repository, options)
    else
      get_content_download_url(repository, options)
    end
  end

  def get_funding(repository)
    contents = @github_service.get_funding(repository)
    return if contents.nil?

    funding_path = DownloadHelper.download(contents.download_url)
    GitHub::Funding.from_file(funding_path)
  end

  def get_asset_download_url(repository, options)
    prerelease = options[:prerelease]
    filter = options[:filter]
    release = @github_service.get_latest_release(repository, prerelease: prerelease)
    if filter.nil?
      release.assets.first.browser_download_url
    else
      release.assets.find { |asset| asset.name.match(filter) }.browser_download_url
    end
  end

  def get_content_download_url(repository, options)
    path = options[:path]
    contents = @github_service.get_contents(repository, path)
    contents.download_url
  end
end

Updater.start(ARGV)
