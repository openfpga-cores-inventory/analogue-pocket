# frozen_string_literal: true

module Analogue
  # Describes the core in general terms, framework requirements, and a list of bitstreams.
  class Core
    SCHEMA = {
      'type' => 'object',
      'required' => %w[core],
      'properties' => {
        'core' => {
          'type' => 'object',
          'required' => %w[metadata framework],
          'properties' => {
            'metadata' => {
              'type' => 'object',
              'required' => %w[platform_ids shortname description author url version date_release],
              'properties' => {
                'platform_ids' => {
                  'type' => 'array',
                  'items' => {
                    'type' => 'string'
                  }
                },
                'shortname' => {
                  'type' => 'string'
                },
                'description' => {
                  'type' => 'string'
                },
                'author' => {
                  'type' => 'string'
                },
                'url' => {
                  'type' => 'string',
                  'format' => 'uri'
                },
                'version' => {
                  'type' => 'string'
                },
                'date_release' => {
                  'type' => 'string',
                  'format' => 'date'
                }
              }
            },
            'framework' => {
              'type' => 'object',
              'required' => %w[version_required sleep_supported dock hardware],
              'properties' => {
                'version_required' => {
                  'type' => 'string'
                },
                'sleep_supported' => {
                  'type' => 'boolean'
                },
                'dock' => {
                  'type' => 'object',
                  'required' => %w[supported analog_output],
                  'properties' => {
                    'supported' => {
                      'type' => 'boolean'
                    },
                    'analog_output' => {
                      'type' => 'boolean'
                    }
                  }
                },
                'hardware' => {
                  'type' => 'object',
                  'required' => %w[link_port],
                  'properties' => {
                    'link_port' => {
                      'type' => 'boolean'
                    }
                  }
                }
              }
            }
          }
        }
      }
    }.freeze

    attr_reader :metadata, :framework

    def initialize(core)
      @metadata = Metadata.new(core.core.metadata)
      @framework = Framework.new(core.core.framework)
    end

    def id
      "#{@metadata.author}.#{@metadata.shortname}"
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
