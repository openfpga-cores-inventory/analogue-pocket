require_relative 'yaml_generator/analogue/pocket_service'
require_relative 'yaml_generator/github/github_service'
require_relative 'yaml_generator/repository_parser'
require_relative 'yaml_generator/repository_service'

class YAMLGenerator
  # 1. Parse Core Repositories
  # 2. Download Core
  # 3. Extract Core
  # 4. Parse Core Metadata
  def call
    github_service = GitHub::GitHubService.new

    repositories = RepositoryParser.parse
    repositories.each do |repository|
      funding = github_service.get_funding(repository.github_repository)

      repository_service = RepositoryService.new
      root_path = repository_service.download_core(repository)
      download_url = repository_service.get_download_url(repository)
      pocket_service = Analogue::PocketService.new(root_path)

      identifier = pocket_service.get_identifier
      core = pocket_service.get_core(identifier)
      pocket_service.export_icon(identifier, "#{identifier}.png")
      platform_id = core.platform_id
      platform = pocket_service.get_platform(platform_id)
      pocket_service.export_image(platform_id, "#{platform_id}.png")
    end
  end
end

if __FILE__ == $0
  generator = YAMLGenerator.new
  generator.call
end
