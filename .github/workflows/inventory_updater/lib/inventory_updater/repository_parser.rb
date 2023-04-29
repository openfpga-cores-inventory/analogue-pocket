require 'ostruct'
require 'yaml'

require_relative 'repository'

class RepositoryParser
  def self.parse(path)
    yml = parse_yml(path)

    repositories = []

    yml.each do |collection|
      owner = collection.username
      collection.cores.each do |core|
        display_name = core.display_name
        repository = parse_core(owner, display_name, core)
        repositories << repository
      end
    end

    return repositories
  end

  private

  private_class_method def self.parse_core(owner, display_name, core)
    name = core.repository

    prerelease = core.prerelease
    path = core.path
    filter = core.filter

    return Repository.new(owner, display_name, name, :prerelease => prerelease, :path => path, :filter => filter)
  end

  private_class_method def self.parse_yml(path)
    json = YAML.load_file(path).to_json
    return JSON.parse(json, object_class: OpenStruct)
  end
end
