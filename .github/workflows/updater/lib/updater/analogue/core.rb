# frozen_string_literal: true

require_relative 'data'

module Analogue
  # FPGA bitstream packaged with JSON definition files
  class Core
    attr_reader :metadata, :framework, :data, :info

    def initialize(core, data, info)
      @metadata = Metadata.new(core.metadata)
      @framework = Framework.new(core.framework)
      @data = Data.new(data)
      @info = info
    end

    def id
      "#{@metadata.author}.#{@metadata.shortname}"
    end

    def platform_id
      @metadata.platform_ids.first
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
  end
end
