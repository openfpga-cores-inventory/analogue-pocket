module Analogue
  class CoreData
    attr_reader :data_slots

    def initialize(data_slots)
      @data_slots = data_slots
    end
  end
end
