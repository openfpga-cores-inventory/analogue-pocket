require 'ostruct'
require 'yaml'

class CacheService
  DATA_DIRECTORY = '_data'
  CORES_FILE = 'cores.yml'

  attr_reader :cores

  def initialize
    @cores = parse_cores
  end

  def get_core(id)
    return @cores.find { |core| core["id"] == id }
  end

  def get_version(id)
    core = get_core(id)
    return core.nil? ? nil : core["version"]
  end

  private

  def parse_cores
    cores_path = File.join(DATA_DIRECTORY, CORES_FILE)
    authors = parse_yml(cores_path)

    return authors.map do |author|
      author["cores"]
    end.flatten
  end

  def parse_yml(path)
    json = YAML.load_file(path).to_json
    return JSON.parse(json)
  end
end
