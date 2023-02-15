require 'chunky_png'

require_relative 'binary_image'
require_relative 'platform_metadata'
require_relative 'definition_service'

module Analogue
  class PlatformService < DefinitionService
    PLATFORMS_DIRECTORY = 'Platforms'
    IMAGES_DIRECTORY = '_images'

    IMAGE_WIDTH = 521
    IMAGE_HEIGHT = 165

    def initialize(root_path)
      super(File.join(root_path, PLATFORMS_DIRECTORY))
    end

    def get_metadata(platform_id)
      metadata_file = "#{platform_id}.json"

      definition = parse_definition(metadata_file)
      return parse_metadata(definition)
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

    def parse_metadata(definition)
      metadata = definition.platform

      category = metadata.category
      name = metadata.name
      manufacturer = metadata.manufacturer
      year = metadata.year

      return PlatformMetadata.new(category, name, manufacturer, year)
    end
  end
end
