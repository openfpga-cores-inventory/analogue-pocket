# frozen_string_literal: true

module Analogue
  # Describes a platform
  class Platform
    attr_reader :category, :name, :manufacturer, :year

    def initialize(platform)
      @category = platform.platform.category
      @name = platform.platform.name
      @manufacturer = platform.platform.manufacturer
      @year = platform.platform.year
    end
  end
end
