require_relative 'data_slot'

module Analogue
  class CoreData
    attr_reader :data, :data_slots

    def initialize(data)
      @data = data

      @data_slots = data.data.data_slots.map do |data_slot|
        DataSlot.new(data_slot)
      end
    end
  end
end
