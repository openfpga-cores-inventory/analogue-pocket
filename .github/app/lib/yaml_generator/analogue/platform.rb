module Analogue
  class Platform
    attr_reader :category, :name, :manufacturer, :year

    def initialize(category, name, manufacturer, year)
      @category = category
      @name = name
      @manufacturer = manufacturer
      @year = year
    end
  end
end
