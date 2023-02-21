module Analogue
  class PlatformMetadata
    attr_reader :platform, :category, :name, :manufacturer, :year

    def initialize(platform)
      @platform = platform

      @category = platform.category
      @name = platform.name
      @manufacturer = platform.manufacturer
      @year = platform.year
    end
  end
end
