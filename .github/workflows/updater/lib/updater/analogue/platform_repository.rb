# frozen_string_literal: true

require 'json'
require 'ostruct'

require_relative 'platform'

module Analogue
  # Repository for interacting with openFPGA platforms
  class PlatformRepository
    attr_reader :platforms_path

    def initialize(platforms_path)
      @platforms_path = platforms_path
    end

    def get_platform(platform_id)
      path = File.join(@platforms_path, "#{platform_id}.json")
      definition = JSON.load_file(path, object_class: OpenStruct)
      Platform.new(definition.platform)
    end
  end
end
