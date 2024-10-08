# frozen_string_literal: true

require 'json'
require 'ostruct'

require_relative 'core'

module Analogue
  # Repository for interacting with openFPGA cores
  class CoreRepository
    CORE_FILE = 'core.json'
    DATA_FILE = 'data.json'
    UPDATERS_FILE = 'updaters.json'
    INFO_FILE = 'info.txt'

    attr_reader :cores_path

    def initialize(cores_path)
      @cores_path = cores_path
    end

    def get_cores
      get_core_ids.map { |core_id| get_core(core_id) }
    end

    def get_core(core_id)
      core = get_definition(core_id)
      data = get_data(core_id)
      updaters = get_updaters(core_id)
      info = get_info(core_id)
      Core.new(core, data, updaters, info)
    end

    private

    def get_core_ids
      Dir.chdir(@cores_path) do
        Dir.glob('*').select { |f| File.directory? f }
      end
    end

    def get_definition(core_id)
      path = File.join(@cores_path, core_id, CORE_FILE)
      definition = JSON.load_file(path, object_class: OpenStruct)
      definition.core
    end

    def get_data(core_id)
      path = File.join(@cores_path, core_id, DATA_FILE)
      definition = JSON.load_file(path, object_class: OpenStruct)
      definition.data
    end

    def get_updaters(core_id)
      path = File.join(@cores_path, core_id, UPDATERS_FILE)
      return nil unless File.exist?(path)

      json = JSON.load_file(path, object_class: OpenStruct)
      Core::Updaters.new(json)
    end

    def get_info(core_id)
      path = File.join(@cores_path, core_id, INFO_FILE)
      return nil unless File.exist?(path)

      File.read(path)
    end
  end
end
