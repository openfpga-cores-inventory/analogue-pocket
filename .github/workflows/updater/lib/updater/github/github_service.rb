# frozen_string_literal: true

require 'base64'
require 'octokit'
require 'open-uri'

require_relative 'funding'

module GitHub
  # Service to interact with GitHub repositories
  class GitHubService
    GITHUB_DIRECTORY = '.github'
    FUNDING_FILE = 'FUNDING.yml'

    attr_reader :client

    def initialize
      @client = Octokit::Client.new(netrc: true)
    end

    def get_funding(repository)
      repo = get_repo(repository)
      path = File.join(GITHUB_DIRECTORY, FUNDING_FILE)
      content = @client.contents(repo, path: path)
      yaml = Base64.decode64(content.content)
      GitHub::Funding.from_yaml(yaml)
    rescue Octokit::NotFound
      nil
    end

    def download_asset(repository, filter, output_path, prerelease: false)
      repo = get_repo(repository)
      release = @client.releases(repo).find { |r| r.prerelease == prerelease }
      assets = @client.release_assets(release.url)
      asset = filter.nil? ? assets.first : assets.find { |asset| asset.name.match?(Regexp.new(filter)) }
      download_file(asset.browser_download_url, output_path)
    end

    def download_content(repository, path, output_path)
      repo = get_repo(repository)
      content = @client.contents(repo, path: path)
      download_file(content.download_url, output_path)
    end

    private

    def get_repo(repository)
      Octokit::Repository.new({ owner: repository.owner, name: repository.name })
    end

    def download_file(url, path)
      URI.parse(url).open('rb') do |data|
        File.binwrite(path, data)
      end
    end
  end
end
