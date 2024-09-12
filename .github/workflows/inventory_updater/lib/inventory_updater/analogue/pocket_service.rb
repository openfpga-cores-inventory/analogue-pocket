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

    def get_cores
      core_ids = get_core_ids
      return core_ids.map do |core_id|
        get_core(core_id)
      end
    end

    def get_info(core_id)
      return @core_service.get_info(core_id)
    end

    def get_updater(core_id)
      return @core_service.get_updater(core_id)
    end

    def export_icon(core_id, output_path)
      @core_service.export_icon(core_id, output_path)
    end

    def get_platform(platform_id)
      return @platform_service.get_platform(platform_id)
    end

    def export_image(platform_id, output_path)
      @platform_service.export_image(platform_id, output_path)
    end

    private

    def get_core_ids
      cores_path = File.join(@root_path, CORES_DIRECTORY)
      Dir.chdir(cores_path) do
        return Dir.glob('*').select { |f| File.directory? f }
      end
    end

    def get_core(directory)
      return @core_service.get_core(directory)
    end
  end
end
