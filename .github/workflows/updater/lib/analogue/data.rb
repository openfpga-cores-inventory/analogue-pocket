# frozen_string_literal: true

module Analogue
  # Describes up to 32 possible data slots. Each slot can be loaded with an asset, loaded and saved to a nonvolatile
  # save file, and contains a number of options.
  class Data
    attr_reader :data_slots

    def initialize(data)
      @data_slots = data.data.data_slots.map do |data_slot|
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

      # Bitmap for the slot's configuration.
      class Parameters
        CORE_SPECIFIC_FILE_MASK = 0x2
        INSTANCE_JSON_MASK = 0x10
        PLATFORM_INDEX_MASK = 0x3000000

        attr_reader :core_specific_file, :instance_json, :platform_index

        def initialize(parameters)
          # Convert parameters to an int to facilitate bitwise operations
          parameters = parameters.to_i(16) if parameters.is_a?(String)

          @core_specific_file = parameters & CORE_SPECIFIC_FILE_MASK != 0
          @instance_json = parameters & INSTANCE_JSON_MASK != 0
          @platform_index = (parameters & PLATFORM_INDEX_MASK) >> 24
        end
      end
    end
  end
end
