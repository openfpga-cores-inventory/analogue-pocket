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

    def get_platform(platform_id)
      platform_file = "#{platform_id}.json"

      definition = parse_definition(platform_file)
      return parse_platform(definition)
    end

    def export_image(platform_id)
      image_file = "#{platform_id}.bin"
      image_path = File.join(@root_path, IMAGES_DIRECTORY, image_file)

      bytes = File.open(image_path, 'rb') { |file| file.read }.bytes.to_a

      image = BinaryImage.render_image(bytes, IMAGE_WIDTH, IMAGE_HEIGHT)

      output_file = "#{platform_id}.png"
      image.save(output_file)
    end

    private

    def parse_platform(definition)
      platform = definition.platform

      category = platform.category
      name = platform.name
      manufacturer = platform.manufacturer
      year = platform.year

      return Platform.new(category, name, manufacturer, year)
    end
  end
end
