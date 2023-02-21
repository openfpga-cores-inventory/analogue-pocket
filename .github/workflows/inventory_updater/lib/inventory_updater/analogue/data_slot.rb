require_relative 'slot_configuration'

module Analogue
  class DataSlot
    attr_reader :data_slot, :required, :parameters, :filename, :extensions, :configuration

    def initialize(data_slot)
      @data_slot = data_slot

      @required = data_slot.required
      @parameters = data_slot.parameters
      @filename = data_slot.filename
      @extensions = data_slot.extensions

      @configuration = SlotConfiguration.new(parameters)
    end
  end
end
