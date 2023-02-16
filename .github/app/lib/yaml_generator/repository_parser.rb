require 'ostruct'
require 'yaml'

require_relative 'repository'

class RepositoryParser
  DATA_DIRECTORY = '_data'
  REPOSITORIES_FILE = 'repos.yml'

  def self.parse
    repositories_path = File.join(DATA_DIRECTORY, REPOSITORIES_FILE)
    yml = YAML.load_file(repositories_path)

    repositories = []

    yml.each do |key|
      collection = OpenStruct.new(key)
      owner = collection.username
      collection.cores.each do |item|
        core = OpenStruct.new(item)
        name = core.repository
        display_name = core.display_name
        prerelease = core.prerelease || false

        repository = Repository.new(owner, name, display_name)
        repository.prerelease = prerelease

        repositories << repository
      end
    end

    return repositories
  end
end
