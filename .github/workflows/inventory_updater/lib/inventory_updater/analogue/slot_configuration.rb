module Analogue
  class SlotConfiguration
    CORE_SPECIFIC_FILE_MASK = 0b000000010
    INSTANCE_JSON_MASK = 0b000010000

    attr_reader :core_sepecific_file, :instance_json

    def initialize(parameters)
      # Convert parameters to an int to facilitate bitwise operations
      parameters = parameters.to_i(16) if parameters.is_a?(String)

      @core_sepecific_file = parameters & CORE_SPECIFIC_FILE_MASK != 0
      @instance_json = parameters & INSTANCE_JSON_MASK != 0
    end
  end
end
