# frozen_string_literal: true

module Analogue
  # Describes a platform
  class Platform
    SCHEMA = {
      'type' => 'object',
      'required' => %w[platform],
      'properties' => {
        'platform' => {
          'type' => 'object',
          'required' => %w[name manufacturer year],
          'properties' => {
            'category' => {
              'type' => 'string'
            },
            'name' => {
              'type' => 'string'
            },
            'manufacturer' => {
              'type' => 'string'
            },
            'year' => {
              'type' => 'integer'
            }
          }
        }
      }
    }.freeze

    attr_reader :category, :name, :manufacturer, :year

    def initialize(platform)
      @category = platform.platform.category
      @name = platform.platform.name
      @manufacturer = platform.platform.manufacturer
      @year = platform.platform.year
    end
  end
end
