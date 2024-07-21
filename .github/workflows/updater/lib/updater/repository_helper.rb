# frozen_string_literal: true

require 'yaml'

require_relative 'core_repository'

# Helper class to parse repositories from YAML
class RepositoryHelper
  def self.from_file(path)
    author_repositories = YAML.load_file(path).map do |author|
      owner = author['username']
      author['cores'].map do |repository|
        name = repository['repository']
        display_name = repository['display_name']
        path = repository['path']
        filter = repository['filter']
        prerelease = repository['prerelease'] || false
        CoreRepository.new(owner, name, display_name, { path: path, filter: filter, prerelease: prerelease })
      end
    end

    author_repositories.flatten
  end
end
