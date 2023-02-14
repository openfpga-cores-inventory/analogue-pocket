require_relative 'platform_metadata'
require_relative 'definition_service'

module Analogue
  class PlatformService < DefinitionService
    PLATFORMS_DIRECTORY = 'Platforms'
    IMAGES_DIRECTORY = '_images'

    def initialize(root_path)
      super(File.join(root_path, PLATFORMS_DIRECTORY))
    end

    def get_metadata(platform_id)
      metadata_file = "#{platform_id}.json"

      definition = parse_definition(metadata_file)
      return parse_metadata(definition)
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
