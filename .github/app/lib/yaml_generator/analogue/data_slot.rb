require_relative 'slot_configuration'

module Analogue
  class DataSlot
    attr_reader :required, :parameters, :filename, :extensions

    def initialize(required, parameters, filename, extensions)
      @required = required
      @parameters = parameters
      @filename = filename
      @extensions = extensions
    end

    def get_configuration
      return SlotConfiguration.parse_parameters(@parameters)
    end
  end
end
