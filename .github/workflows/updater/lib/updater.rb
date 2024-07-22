# frozen_string_literal: true

require 'thor'
require 'yaml'

require_relative 'updater/analogue'
require_relative 'updater/cache_service'
require_relative 'updater/github'
require_relative 'updater/jekyll'
require_relative 'updater/download_helper'
require_relative 'updater/repository_helper'
require_relative 'updater/zip_helper'

# Updater CLI
class Updater < Thor
  AUTHORS_DIRECTORY = 'authors'
  CORES_DIRECTORY = 'cores'
  PLATFORMS_DIRECTORY = 'platforms'
  REPOSITORIES_DIRECTORY = 'repositories'

  REPOSITORIES_FILE = 'repositories.yml'

  attr_reader :github_service, :jekyll_service, :cache_service, :core_repository

  class_option :site_path, default: Dir.pwd

  def initialize(args, opts, config)
    super(args, opts, config)

    @github_service = GitHub::GitHubService.new
    @jekyll_service = Jekyll::JekyllService.new(options[:site_path])
    @cache_service = CacheService.new(@jekyll_service.data_path)
  end

  option :force, type: :boolean, default: false
  desc 'update-cores', 'Update openFGPA cores'
  def update_cores
    repositories_path = File.join(@jekyll_service.data_path, REPOSITORIES_FILE)
    repositories = RepositoryHelper.from_file(repositories_path)
    repositories.each do |repository|
      repo = GitHub::Repository.new(repository.owner, repository.name)
      download_url = get_download_url(repo, repository.options)

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

        write_repository(core.id, repo)

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
      "#{core.metadata.shortname} - #{core.metadata.version}",
      core.metadata.date_release,
      [platform.category, core.id],
      core.metadata.platform_ids,
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

  def write_repository(core_id, repository)
    path = File.join(@jekyll_service.data_path, REPOSITORIES_DIRECTORY, "#{core_id}.yml")
    File.write(path, repository.to_yaml)
  end

  def get_download_url(repository, options)
    path = options[:path]
    if path.nil?
      get_asset_download_url(repository, options)
    else
      get_content_download_url(repository, options)
    end
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
