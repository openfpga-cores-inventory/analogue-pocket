# frozen_string_literal: true

require 'json'
require 'ostruct'

module Analogue
  # Helper class to parse JSON definitions
  class DefinitionHelper
    def self.parse_json(path)
      json = File.read(path)
      JSON.parse(json, object_class: OpenStruct)
    end
  end
end
