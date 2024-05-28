# frozen_string_literal: true

require 'base64'
require 'octokit'

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

    def get_asset_url(repository, filter, prerelease: false)
      repo = get_repo(repository)
      release = @client.releases(repo).find { |r| r.prerelease == prerelease }
      assets = @client.release_assets(release.url)
      asset = filter.nil? ? assets.first : assets.find { |asset| asset.name.match?(Regexp.new(filter)) }
      asset.browser_download_url
    end

    def get_content_url(repository, path)
      repo = get_repo(repository)
      content = @client.contents(repo, path: path)
      content.download_url
    end

    private

    def get_repo(repository)
      Octokit::Repository.new({ owner: repository.owner, name: repository.name })
    end
  end
end
