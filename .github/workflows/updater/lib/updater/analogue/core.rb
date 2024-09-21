# frozen_string_literal: true

module Analogue
  class Core
    LICENSE_DATA_SLOTS = %w[JTBETA License].freeze

    attr_reader :metadata, :framework, :data_slots, :info, :requires_license

    def initialize(core, data, info)
      @metadata = Metadata.new(core.metadata)
      @framework = Framework.new(core.framework)
      @data_slots = data.data_slots.map do |data_slot|
        DataSlot.new(data_slot)
      end
      @info = info
      @requires_license = requires_license?
    end

    def id
      "#{@metadata.author}.#{@metadata.shortname}"
    end

    def platform_id
      @metadata.platform_ids.first
    end

    private

    def requires_license?
      @data_slots.any? { |data_slot| LICENSE_DATA_SLOTS.include?(data_slot.name) }
    end

    # Describes the core in general terms
    class Metadata
      attr_reader :platform_ids, :shortname, :description, :author, :url, :version, :date_release

      def initialize(metadata)
        @platform_ids = metadata.platform_ids
        @shortname = metadata.shortname
        @description = metadata.description
        @author = metadata.author
        @url = metadata.url
        @version = metadata.version
        @date_release = metadata.date_release
      end
    end

    # Describes the Framework requirements
    class Framework
      attr_reader :version_required, :sleep_supported, :dock, :hardware

      def initialize(framework)
        @version_required = framework.version_required
        @sleep_supported = framework.sleep_supported
        @dock = Dock.new(framework.dock)
        @hardware = Hardware.new(framework.hardware)
      end

      # Describes the Dock requirements
      class Dock
        attr_reader :supported, :analog_output

        def initialize(dock)
          @supported = dock.supported
          @analog_output = dock.analog_output
        end
      end

      # Describes the Hardware requirements
      class Hardware
        attr_reader :link_port

        def initialize(hardware)
          @link_port = hardware.link_port
        end
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
        CORE_SPECIFIC_FILE_MASK = 0b000000010
        INSTANCE_JSON_MASK = 0b000010000

        attr_reader :core_specific_file, :instance_json

        def initialize(parameters)
          # Convert parameters to an int to facilitate bitwise operations
          parameters = parameters.to_i(16) if parameters.is_a?(String)

          @core_specific_file = parameters & CORE_SPECIFIC_FILE_MASK != 0
          @instance_json = parameters & INSTANCE_JSON_MASK != 0
        end
      end
    end
  end
end
