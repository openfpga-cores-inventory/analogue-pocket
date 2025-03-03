# frozen_string_literal: true

require 'yaml'

require_relative 'core'
require_relative 'source'

module Inventory
  # Repository for interacting with openFPGA core sources
  class InventoryService
    CORES_DIRECTORY = 'cores'
    PLATFORMS_DIRECTORY = 'platforms'

    SOURCES_FILE = 'sources.yml'

    attr_reader :data_path, :cores_path, :platforms_path, :cores_cache, :platforms_cache

    def initialize(data_path)
      @data_path = data_path
      @cores_path = File.join(data_path, CORES_DIRECTORY)
      @platforms_path = File.join(data_path, PLATFORMS_DIRECTORY)
      @cores_cache = {}
      @platforms_cache = {}
    end

    def core(core_id)
      return @cores_cache[core_id] if @cores_cache.key?(core_id)

      path = File.join(@cores_path, "#{core_id}.yml")
      return nil unless File.exist?(path)

      permitted_classes = [
        Inventory::Core, Inventory::Release,
        GitHub::Repository, GitHub::Repository::Owner, GitHub::Funding,
        Analogue::Core, Analogue::Core::Metadata, Analogue::Core::Framework, Analogue::Core::Framework::Dock, Analogue::Core::Framework::Hardware,
        Analogue::Data, Analogue::Data::DataSlot, Analogue::Data::DataSlot::Parameters,
        Analogue::Updaters, Analogue::Updaters::License
      ]

      @cores_cache[core_id] = YAML.safe_load_file(path, permitted_classes: permitted_classes)
    end

    def cores
      core_ids.map { |core_id| core(core_id) }
    end

    def sources
      sources_path = File.join(@data_path, SOURCES_FILE)
      sources = YAML.safe_load_file(sources_path)
      sources.map do |source|
        repository = source['repository']
        contents = source['contents'] || []
        assets = contents.empty? ? source['assets'] || [/\.zip$/] : []
        Source.new(repository, assets, contents)
      end
    end

    def platform(platform_id)
      return @platforms_cache[platform_id] if @platforms_cache.key?(platform_id)

      path = File.join(@platforms_path, "#{platform_id}.yml")
      return nil unless File.exist?(path)

      @platforms_cache[platform_id] = YAML.safe_load_file(path, permitted_classes: [Analogue::Platform])
    end

    def write_core(core)
      @cores_cache[core.id] = core
      path = File.join(@cores_path, "#{core.id}.yml")
      File.write(path, core.to_yaml)
    end

    def write_platform(platform_id, platform)
      @platforms_cache[platform_id] = platform
      path = File.join(@platforms_path, "#{platform_id}.yml")
      File.write(path, platform.to_yaml)
    end

    private

    def core_ids
      Dir.children(@cores_path).map { |file_name| File.basename(file_name, '.yml') }
    end
  end
end
