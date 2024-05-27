# frozen_string_literal: true

module Analogue
  # Describes up to 32 possible data slots.
  class Data
    attr_reader :data_slots

    def initialize(data)
      @data_slots = data.data_slots.map do |data_slot|
        DataSlot.new(data_slot)
      end
    end

    # Describes a single data slot.
    class DataSlot
      attr_reader :name, :required, :parameters, :filename, :extensions

      def initialize(data_slot)
        @name = data_slot.name
        @required = data_slot.required
        @parameters = Parameters.new(data_slot.parameters)
        @filename = data_slot.filename
        @extensions = data_slot.extensions
      end

      def core_specific_file
        @parameters.core_sepecific_file
      end

      def instance_json
        @parameters.instance_json
      end

      # Bitmap for the slot's configuration.
      class Parameters
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
  end
end
