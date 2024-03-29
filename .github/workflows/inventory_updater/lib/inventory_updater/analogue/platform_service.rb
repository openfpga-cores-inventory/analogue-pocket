require_relative 'binary_image'
require_relative 'platform'
require_relative 'definition_service'

module Analogue
  class PlatformService < DefinitionService
    IMAGES_DIRECTORY = '_images'

    IMAGE_WIDTH = 521
    IMAGE_HEIGHT = 165

    def initialize(root_path)
      super(root_path)
    end

    def get_platform(id)
      platform_file = "#{id}.json"
      platform = parse_json(platform_file)
      return Platform.new(platform)
    end

    def export_image(id, output_path)
      image_file = "#{id}.bin"
      image_path = File.join(@root_path, IMAGES_DIRECTORY, image_file)
      image = BinaryImage.convert_image(image_path, IMAGE_WIDTH, IMAGE_HEIGHT)
      image.save(output_path)
    end
  end
end
