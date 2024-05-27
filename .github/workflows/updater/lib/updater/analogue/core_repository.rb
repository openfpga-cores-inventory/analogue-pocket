# frozen_string_literal: true

require_relative 'core'
require_relative 'data'
require_relative 'definition_helper'

module Analogue
  # Repository for interacting with OpenFPGA cores
  class CoreRepository
    CORE_FILE = 'core.json'
    DATA_FILE = 'data.json'
    INFO_FILE = 'info.txt'

    attr_reader :cores_path

    def initialize(cores_path)
      @cores_path = cores_path
    end

    def get_cores
      core_ids = get_core_ids
      core_ids.map { |core_id| get_core(core_id) }
    end

    def get_core(core_id)
      core = _get_core(core_id)
      data = get_data(core_id)
      info = get_info(core_id)

      Core.new(core, data, info)
    end

    private

    def get_core_ids
      Dir.children(@cores_path)
    end

    def _get_core(core_id)
      path = File.join(@cores_path, core_id, CORE_FILE)
      definition = DefinitionHelper.parse_json(path)
      definition.core
    end

    def get_data(core_id)
      path = File.join(@cores_path, core_id, DATA_FILE)
      definition = DefinitionHelper.parse_json(path)
      definition.data
    end

    def get_info(core_id)
      path = File.join(@cores_path, core_id, INFO_FILE)
      return nil unless File.exist?(path)

      File.read(path)
    end
  end
end
