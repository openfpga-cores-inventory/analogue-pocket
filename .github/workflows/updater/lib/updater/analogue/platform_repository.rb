# frozen_string_literal: true

require_relative 'definition_helper'
require_relative 'platform'

module Analogue
  # Repository for interacting with OpenFPGA platforms
  class PlatformRepository
    attr_reader :platforms_path

    def initialize(platforms_path)
      @platforms_path = platforms_path
    end

    def get_platform(platform_id)
      platform = _get_platform(platform_id)
      Platform.new(platform)
    end

    private

    def _get_platform(platform_id)
      path = File.join(@platforms_path, "#{platform_id}.json")
      definition = DefinitionHelper.parse_json(path)
      definition.platform
    end
  end
end
