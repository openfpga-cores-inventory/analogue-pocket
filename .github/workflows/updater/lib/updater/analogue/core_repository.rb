# frozen_string_literal: true

require 'json'
require 'ostruct'

require_relative 'core'

module Analogue
  # Repository for interacting with openFPGA cores
  class CoreRepository
    CORE_FILE = 'core.json'
    DATA_FILE = 'data.json'
    INFO_FILE = 'info.txt'

    attr_reader :cores_path

    def initialize(cores_path)
      @cores_path = cores_path
    end

    def get_cores
      get_core_ids.map { |core_id| get_core(core_id) }
    end

    def get_core(core_id)
      core = get_core_definition(core_id)
      data = get_data_definition(core_id)
      info = get_info(core_id)
      Core.new(core, data, info)
    end

    private

    def get_core_ids
      Dir.children(@cores_path)
    end

    def get_core_definition(core_id)
      path = File.join(@cores_path, core_id, CORE_FILE)
      definition = JSON.load_file(path, object_class: OpenStruct)
      definition.core
    end

    def get_data_definition(core_id)
      path = File.join(@cores_path, core_id, DATA_FILE)
      definition = JSON.load_file(path, object_class: OpenStruct)
      definition.data
    end

    def get_info(core_id)
      path = File.join(@cores_path, core_id, INFO_FILE)
      return nil unless File.exist?(path)

      File.read(path)
    end
  end
end
