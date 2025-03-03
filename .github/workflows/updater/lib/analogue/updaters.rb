# frozen_string_literal: true

module Analogue
  # Describes updaters configuration.
  class Updaters
    attr_reader :license

    def initialize(updaters)
      @license = License.new(updaters.license)
    end

    # Describes a single license.
    class License
      attr_reader :filename

      def initialize(license)
        @filename = license.filename
      end
    end
  end
end
