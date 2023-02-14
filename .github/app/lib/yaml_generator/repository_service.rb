require 'octokit'
require 'open-uri'
require 'tempfile'
require 'tmpdir'
require 'zip'

require_relative 'github/github_service'

class RepositoryService
  @@github_service = GitHub::GitHubService.new

  def download_core(repository, prerelease = false)
    download_url = get_download_url(repository, prerelease)
    name = repository.name

    # write the core archive to a temp file
    temp_file = Tempfile.new([name, 'zip'], :binmode => true)
    URI.open(download_url, 'rb') do |asset|
      temp_file.write(asset.read)
    end

    # extract the core archive to a temp folder
    temp_dir = Dir.mktmpdir(name)
    Zip::File.open(temp_file.path) do |zip|
      zip.each do |file|
        file_path = File.join(temp_dir, file.name)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip.extract(file, file_path) unless File.exist?(file_path)
      end
    end

    # delete the temp file
    temp_file.unlink

    return temp_dir
  end

  def get_download_url(repository, prerelease = false)
    github_repository = repository.github_repository
    path = repository.resource_filter.path
    prefix = repository.resource_filter.prefix

    if path.nil?
      # get the download url of the core archive from the latest release
      release = @@github_service.get_latest_release(github_repository, prerelease)
      assets = @@github_service.get_release_assets(release)
      core_asset = prefix.nil? ? assets[0] : assets.find { |asset| asset.name.start_with?(prefix) }
      download_url = core_asset.browser_download_url
    else
      # get the download url of the core archive from the path
      resources = @@github_service.get_contents(github_repository, :path => path)
      resource = prefix.nil? ? resources : resources.find { |content| content.name.start_with?(prefix) }
      download_url = resource.download_url
    end

    return download_url
  end
end
