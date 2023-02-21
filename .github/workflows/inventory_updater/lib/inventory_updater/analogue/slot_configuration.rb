module Analogue
  class SlotConfiguration
    CORE_SPECIFIC_FILE_MASK = 0b000000010
    INSTANCE_JSON_MASK = 0b000010000

    attr_accessor :core_sepecific_file, :instance_json

    def self.parse_parameters(parameters)
      # Convert parameters to an int to facilitate bitwise operations
      parameters = parameters.to_i(16) if parameters.is_a?(String)

      slot_configuration = SlotConfiguration.new

      slot_configuration.core_sepecific_file = parameters & CORE_SPECIFIC_FILE_MASK != 0
      slot_configuration.instance_json = parameters & INSTANCE_JSON_MASK != 0

      return slot_configuration
    end

    def initialize
      @core_sepecific_file = false
      @instance_json = false
    end
  end
end
