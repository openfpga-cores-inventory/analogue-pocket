# frozen_string_literal: true

require_relative 'core_repository'
require_relative 'image_helper'
require_relative 'platform_repository'

module Analogue
  # Service to interact with openFPGA structured data
  class OpenFPGAService
    CORES_DIRECTORY = 'Cores'
    PLATFORMS_DIRECTORY = 'Platforms'
    IMAGES_DIRECTORY = '_images'

    ICON_FILE = 'icon.bin'

    ICON_WIDTH = 36
    ICON_HEIGHT = 36

    IMAGE_WIDTH = 521
    IMAGE_HEIGHT = 165

    attr_reader :openfpga_path, :core_repository, :platform_repository

    def initialize(openfpga_path)
      @openfpga_path = openfpga_path

      cores_path = File.join(@openfpga_path, CORES_DIRECTORY)
      @core_repository = CoreRepository.new(cores_path)

      platforms_path = File.join(@openfpga_path, PLATFORMS_DIRECTORY)
      @platform_repository = PlatformRepository.new(platforms_path)
    end

    def get_cores
      @core_repository.get_cores
    end

    def get_platform(platform_id)
      @platform_repository.get_platform(platform_id)
    end

    def export_icon(core_id, output_path)
      icon_path = File.join(@openfpga_path, CORES_DIRECTORY, core_id, ICON_FILE)
      ImageHelper.export(icon_path, ICON_WIDTH, ICON_HEIGHT, output_path)
    end

    def export_image(platform_id, output_path)
      image_path = File.join(@openfpga_path, PLATFORMS_DIRECTORY, IMAGES_DIRECTORY, "#{platform_id}.bin")
      ImageHelper.export(image_path, IMAGE_WIDTH, IMAGE_HEIGHT, output_path)
    end
  end
end
