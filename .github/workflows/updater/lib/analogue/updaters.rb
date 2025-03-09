# frozen_string_literal: true

module Analogue
  # Describes updaters configuration.
  class Updaters
    SCHEMA = {
      'type' => 'object',
      'properties' => {
        'license' => {
          'type' => 'object',
          'required' => %w[filename],
          'properties' => {
            'filename' => {
              'type' => 'string'
            }
          }
        },
        'previous' => {
          'type' => 'array',
          'items' => {
            'type' => 'object',
            'required' => %w[shortname author platform_id],
            'properties' => {
              'shortname' => {
                'type' => 'string'
              },
              'author' => {
                'type' => 'string'
              },
              'platform_id' => {
                'type' => 'string'
              }
            }
          }
        }
      }
    }.freeze

    attr_reader :license, :previous

    def initialize(updaters)
      @license = License.new(updaters.license)
      @previous = (updaters.previous || []).map do |previous|
        Previous.new(previous)
      end
    end

    # Describes a license.
    class License
      attr_reader :filename

      def initialize(license)
        @filename = license.filename
      end
    end

    # Describes a previous core.
    class Previous
      attr_reader :shortname, :author, :platform_id

      def initialize(previous)
        @shortname = previous.shortname
        @author = previous.author
        @platform_id = previous.platform_id
      end
    end
  end
end
