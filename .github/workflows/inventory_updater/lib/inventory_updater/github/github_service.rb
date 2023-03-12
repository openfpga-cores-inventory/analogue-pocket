require 'base64'
require 'octokit'
require 'yaml'

require_relative 'funding'

module GitHub
  class GitHubService
    GITHUB_REPOSITORY = '.github'
    GITHUB_FOLDER = '.github'
    FUNDING_FILE = 'FUNDING.yml'

    attr_reader :client

    def initialize
      @client = Octokit::Client.new(:netrc => true)
    end

    def contents(repository, path)
      return @client.contents(repository, :path => path)
    end

    def funding(repository)
      begin
        path = File.join(GITHUB_FOLDER, FUNDING_FILE)
        content = file_content(repository, path)
      rescue Octokit::NotFound
        begin
          # Fallback to default community health file
          github_repository = Octokit::Repository.new("#{repository.owner}/#{GITHUB_REPOSITORY}")
          path = FUNDING_FILE
          content = file_content(github_repository, FUNDING_FILE)
        rescue Octokit::NotFound
          # Failed to find FUNDING.yml
          return nil
        end
      end

      funding = YAML.load(content)
      return Funding.new(funding)
    end

    def latest_release(repository, prerelease = false)
      if !prerelease
        return @client.latest_release(repository)
      else
        releases = @client.releases(repository)
        return releases.find { |release| release.prerelease == prerelease }
      end      
    end

    def release_assets(release)
      return @client.release_assets(release.url)
    end

    private

    def file_content(repository, path)
      resource = contents(repository, path)
      return Base64.decode64(resource.content)
    end
  end
end
