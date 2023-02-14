require_relative 'yaml_generator/repository'
require_relative 'yaml_generator/resource_filter'
require_relative 'yaml_generator/analogue/core_service'
require_relative 'yaml_generator/analogue/platform_service'
require_relative 'yaml_generator/github/github_service'
require_relative 'yaml_generator/repository_service'

class YAMLGenerator
  # 1. Parse Core Repositories
  # 2. Download Core
  # 3. Extract Core
  # 4. Parse Core Metadata
  def call
    owner = 'agg23'
    name = 'openfpga-arduboy'
    display_name = 'Arduboy for Analogue Pocket'
    path = nil
    prefix = nil

    repository = Repository.new(owner, name, display_name)
    repository.resource_filter.path = path
    repository.resource_filter.prefix = prefix

    github_service = GitHub::GitHubService.new
    funding = github_service.get_funding(repository.github_repository)

    repository_service = RepositoryService.new
    core_path = repository_service.download_core(repository)
    core_service = Analogue::CoreService.new(core_path)
    platform_service = Analogue::PlatformService.new(core_path)

    core = core_service.get_core('agg23.Arduboy')
    platform_id = core.description.metadata.platform_ids.first
    metadata = platform_service.get_metadata(platform_id)

    puts core.inspect
  end
end

if __FILE__ == $0
  generator = YAMLGenerator.new
  generator.call
end
