# frozen_string_literal: true

require 'base64'
require 'octokit'

require_relative 'asset'
require_relative 'content'
require_relative 'release'

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
      path = File.join(GITHUB_DIRECTORY, FUNDING_FILE)
      get_contents(repository, path)
    end

    def get_latest_release(repository, prerelease: false)
      repo = Octokit::Repository.new({ owner: repository.owner, name: repository.name })
      release = @client.releases(repo).find { |r| r.prerelease == prerelease }
      assets = release.assets.map do |asset|
        GitHub::Asset.new(asset.name, asset.browser_download_url)
      end
      GitHub::Release.new(assets)
    end

    def get_contents(repository, path)
      repo = Octokit::Repository.new({ owner: repository.owner, name: repository.name })
      contents = @client.contents(repo, path: path)
      GitHub::Content.new(contents.name, contents.download_url)
    rescue Octokit::NotFound
      nil
    end
  end
end
