require 'base64'
require 'octokit'

require_relative 'funding'

module GitHub
  class GitHubService
    GITHUB_REPOSITORY = '.github'
    GITHUB_FOLDER = '.github'
    FUNDING_FILE = 'FUNDING.yml'

    @@client = Octokit::Client.new(:netrc => true)

    def get_contents(repository, path)
      return @@client.contents(repo, :path => path)
    end

    def get_funding(repository)
      begin
        # Check if the repository has a FUNDING.yml
        path = File.join(GITHUB_FOLDER, FUNDING_FILE)
        content = get_file_content(repository, path)
      rescue Octokit::NotFound
        begin
          github_repository = Octokit::Repository.new("#{repository.owner}/#{GITHUB_REPOSITORY}")
          path = FUNDING_FILE
          content = get_file_content(github_repository, FUNDING_FILE)
        rescue Octokit::NotFound
          # Failed to find FUNDING.yml
          return nil
        end
      end

      return GitHub::Funding.parse_content(content)
    end

    def get_latest_release(repository, prerelease = false)
      releases = @@client.releases(repository)
      return releases.find { |release| release.prerelease == prerelease }
    end

    def get_release_assets(release)
      return @@client.release_assets(release.url)
    end

    private

    def get_file_content(repository, path)
      resource = @@client.contents(repository, :path => path)
      return Base64.decode64(resource.content)
    end
  end
end
