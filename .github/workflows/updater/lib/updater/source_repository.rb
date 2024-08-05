# frozen_string_literal: true

require 'yaml'

require_relative 'source'
require_relative 'github/repository'

# SourceRepository class
class SourceRepository
  attr_reader :sources_path

  def initialize(sources_path)
    @sources_path = sources_path
  end

  def get_sources
    sources = YAML.load_file(@sources_path).map do |author|
      owner = author['username']
      author['cores'].map do |repository|
        name = repository['repository']
        path = repository['path']
        filter = repository['filter']
        prerelease = repository['prerelease'] || false
        Source.new(GitHub::Repository.new(owner, name), { path: path, filter: filter, prerelease: prerelease })
      end
    end
    sources.flatten
  end
end
