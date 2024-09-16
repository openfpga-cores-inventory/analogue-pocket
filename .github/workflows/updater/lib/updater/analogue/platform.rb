# frozen_string_literal: true

module Analogue
  # Describes a platform
  class Platform
    attr_reader :category, :name, :manufacturer, :year

    def initialize(platform)
      @category = platform.category
      @name = platform.name
      @manufacturer = platform.manufacturer
      @year = platform.year
    end
  end
end
