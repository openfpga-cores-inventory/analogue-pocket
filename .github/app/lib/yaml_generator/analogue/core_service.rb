require_relative 'binary_image'
require_relative 'core'
require_relative 'core_data'
require_relative 'core_definition'
require_relative 'core_metadata'
require_relative 'data_slot'
require_relative 'definition_service'

module Analogue
  class CoreService < DefinitionService
    CORE_FILE = 'core.json'
    DATA_FILE = 'data.json'

    ICON_FILE = 'icon.bin'

    ICON_WIDTH = 36
    ICON_HEIGHT = 36

    def initialize(root_path)
      super(root_path)
    end

    def get_core(identifier)
      definition = parse_core_definition(identifier)
      data = parse_data(identifier)

      return Core.new(definition, data)
    end

    def export_icon(identifier, output_path)
      icon_path = File.join(@root_path, identifier, ICON_FILE)

      unless File.exist?(icon_path)
        return
      end

      icon = BinaryImage.convert_image(icon_path, ICON_WIDTH, ICON_HEIGHT)
      icon.save(output_path)
    end

    private

    def parse_core_definition(identifier)
      core_path = File.join(identifier, CORE_FILE)
      definition = parse_definition(core_path)

      metadata = parse_metadata(definition)

      return CoreDefinition.new(metadata)
    end

    def parse_metadata(definition)
      metadata = definition.core.metadata

      platform_ids = metadata.platform_ids
      shortname = metadata.shortname
      description = metadata.description
      author = metadata.author
      url = metadata.url
      version = metadata.version
      date_release = metadata.date_release

      return CoreMetadata.new(platform_ids, shortname, description, author, url, version, date_release)
    end

    def parse_data(identifier)
      data_path = File.join(identifier, DATA_FILE)
      definition = parse_definition(data_path)

      data_slots = parse_data_slots(definition)

      return CoreData.new(data_slots)
    end

    def parse_data_slots(definition)
      data_slots = definition.data.data_slots

      return data_slots.map do |data_slot|
        required = data_slot.required
        parameters = data_slot.parameters
        filename = data_slot.filename
        extensions = data_slot.extensions

        DataSlot.new(required, parameters, filename, extensions)
      end
    end
  end
end
