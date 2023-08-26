require_relative 'provenance'

module Analogue
  class Updater
    attr_reader :updater, :previous

    def initialize(updater)
      @updater = updater

      @previous = @updater.previous.map do |provenance|
        Provenance.new(provenance)
      end
  end
end
