# frozen_string_literal: true

require 'octokit'

require_relative 'commit'
require_relative 'contents'
require_relative 'release'
require_relative 'repository'

module GitHub
  # Repository to interact with GitHub repositories
  class GitHubService
    GITHUB_DIRECTORY = '.github'
    FUNDING_FILE = 'FUNDING.yml'

    attr_reader :client

    def initialize
      @client = Octokit::Client.new(netrc: true)
    end

    def commits(repository, options = {})
      @client.commits(repository, options).map do |commit|
        GitHub::Commit.new(commit)
      end
    end

    def contents(repository, options = {})
      contents = @client.contents(repository, options)
      GitHub::Contents.new(contents)
    rescue Octokit::NotFound
      nil
    end

    def funding(repository)
      funding_path = File.join(GITHUB_DIRECTORY, FUNDING_FILE)
      contents(repository, { path: funding_path })
    end

    def releases(repository)
      @client.releases(repository).map do |release|
        GitHub::Release.new(release)
      end
    end

    def repository(repository)
      repo = @client.repository(repository)
      GitHub::Repository.new(repo)
    end
  end
end
