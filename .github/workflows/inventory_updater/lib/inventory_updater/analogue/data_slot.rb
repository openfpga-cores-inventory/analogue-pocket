require_relative 'slot_configuration'

module Analogue
  class DataSlot
    attr_reader :required, :parameters, :filename, :extensions

    def configuration
      return SlotConfiguration.parse_parameters(@parameters)
    end

    def initialize(required, parameters, options={})
      @required = required
      @parameters = parameters
      @filename = options[:filename]
      @extensions = options[:extensions]
    end
  end
end
