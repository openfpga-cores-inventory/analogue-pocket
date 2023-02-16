require_relative 'core_service'
require_relative 'platform_service'

module Analogue
  class PocketService
    CORES_DIRECTORY = 'Cores'
    PLATFORMS_DIRECTORY = 'Platforms'

    attr_reader :root_path, :core_service, :platform_service

    def initialize(root_path)
      @root_path = root_path

      cores_path = File.join(root_path, CORES_DIRECTORY)
      @core_service = CoreService.new(cores_path)

      platforms_path = File.join(root_path, PLATFORMS_DIRECTORY)
      @platform_service = PlatformService.new(platforms_path)
    end

    def get_identifier
      return @core_service.get_identifier
    end

    def get_core(identifier)
      return @core_service.get_core(identifier)
    end

    def export_icon(identifier, output_path)
      @core_service.export_icon(identifier, output_path)
    end

    def get_platform(platform_id)
      return @platform_service.get_platform(platform_id)
    end

    def export_image(platform_id, output_path)
      @platform_service.export_image(platform_id, output_path)
    end
  end
end
