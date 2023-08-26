module Analogue
  class Updater
    attr_reader :updater

    def previous
      return @updater.previous
    end

    def initialize(updater)
      @updater = updater
    end
  end
end
