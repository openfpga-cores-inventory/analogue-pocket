require_relative 'platform_metadata'

module Analogue
  class Platform
    attr_reader :platform, :metadata

    def initialize(platform)
      @platform = platform
      @metadata = PlatformMetadata.new(platform.platform)
    end
  end
end
