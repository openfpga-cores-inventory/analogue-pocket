# frozen_string_literal: true

require 'chunky_png'
require 'json'
require 'json-schema'
require 'ostruct'

require_relative 'core'
require_relative 'data'
require_relative 'platform'
require_relative 'updaters'

module Analogue
  # Service to interact with openFPGA assets
  class OpenFPGAService
    CORES_DIRECTORY = 'Cores'
    PLATFORMS_DIRECTORY = 'Platforms'

    CORE_FILE = 'core.json'
    DATA_FILE = 'data.json'
    UPDATERS_FILE = 'updaters.json'
    INFO_FILE = 'info.txt'

    IMAGES_DIRECTORY = '_images'
    ICON_FILE = 'icon.bin'

    ICON_WIDTH = 36
    ICON_HEIGHT = 36

    IMAGE_WIDTH = 521
    IMAGE_HEIGHT = 165

    attr_reader :cores_path, :platforms_path

    def initialize(openfpga_path)
      @cores_path = File.join(openfpga_path, CORES_DIRECTORY)
      @platforms_path = File.join(openfpga_path, PLATFORMS_DIRECTORY)
    end

    def cores
      core_ids.map { |core_id| core(core_id) }
    end

    def data(core_id)
      data_path = File.join(@cores_path, core_id, DATA_FILE)
      JSON::Validator.validate!(Data::SCHEMA, JSON.load_file(data_path))
      data = JSON.load_file(data_path, object_class: OpenStruct)
      Analogue::Data.new(data)
    end

    def export_icon(core_id, output_path)
      icon_path = File.join(@cores_path, core_id, ICON_FILE)
      export_asset(icon_path, ICON_WIDTH, ICON_HEIGHT, output_path)
    end

    def export_image(platform_id, output_path)
      image_path = File.join(@platforms_path, IMAGES_DIRECTORY, "#{platform_id}.bin")
      export_asset(image_path, IMAGE_WIDTH, IMAGE_HEIGHT, output_path)
    end

    def info(core_id)
      info_path = File.join(@cores_path, core_id, INFO_FILE)
      return unless File.exist?(info_path)

      File.read(info_path)
    end

    def updaters(core_id)
      updaters_path = File.join(@cores_path, core_id, UPDATERS_FILE)
      return unless File.exist?(updaters_path)

      JSON::Validator.validate!(Updaters::SCHEMA, JSON.load_file(updaters_path))
      updaters = JSON.load_file(updaters_path, object_class: OpenStruct)
      Analogue::Updaters.new(updaters)
    end

    def platform(platform_id)
      platform_path = File.join(@platforms_path, "#{platform_id}.json")
      return unless File.exist?(platform_path)

      JSON::Validator.validate!(Platform::SCHEMA, JSON.load_file(platform_path))
      platform = JSON.load_file(platform_path, object_class: OpenStruct)
      Analogue::Platform.new(platform)
    end

    private

    def core_ids
      Dir.chdir(@cores_path) do
        Dir.glob('*').select { |f| File.directory? f }
      end
    end

    def core(core_id)
      core_path = File.join(@cores_path, core_id, CORE_FILE)
      JSON::Validator.validate!(Core::SCHEMA, JSON.load_file(core_path))
      core = JSON.load_file(core_path, object_class: OpenStruct)
      Analogue::Core.new(core)
    end

    def export_asset(asset_path, width, height, output_path, invert: true)
      return unless File.exist?(asset_path)

      # Read the brightness values from the binary file
      bytes = File.binread(asset_path)

      # Unpack the bytes into their brightness values
      brightness = bytes.unpack('s*')

      # Convert the brightness values to their RGB representation
      rgb_brightness = brightness.flat_map { |value| [invert ? 255 - value : value] * 3 }

      # Pack the RGB values into a byte stream
      bytes = rgb_brightness.pack('C*')

      # Create a new image with the specified width and height
      rotated_image = ChunkyPNG::Image.from_rgb_stream(height, width, bytes)

      # Rotate the image 90 degrees clockwise
      image = rotated_image.rotate_right

      image.save(output_path)
    end
  end
end
