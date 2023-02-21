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

    def get_core(id)
      definition = parse_definition(id)
      data = parse_data(id)
      return Core.new(definition, data)
    end

    def export_icon(id, output_path)
      icon_path = File.join(@root_path, id, ICON_FILE)

      unless File.exist?(icon_path)
        return
      end
      icon = BinaryImage.convert_image(icon_path, ICON_WIDTH, ICON_HEIGHT)
      icon.save(output_path)
    end

    private

    def parse_definition(id)
      core_path = File.join(id, CORE_FILE)
      json = parse_json(core_path)

      metadata = parse_metadata(json)

      return CoreDefinition.new(metadata)
    end

    def parse_metadata(json)
      metadata = json.core.metadata

      platform_ids = metadata.platform_ids
      shortname = metadata.shortname
      description = metadata.description
      author = metadata.author
      url = metadata.url
      version = metadata.version
      date_release = metadata.date_release

      return CoreMetadata.new(platform_ids, shortname, description, author, url, version, date_release)
    end

    def parse_data(id)
      data_path = File.join(id, DATA_FILE)
      json = parse_json(data_path)

      data_slots = parse_data_slots(json)

      return CoreData.new(data_slots)
    end

    def parse_data_slots(definition)
      data_slots = definition.data.data_slots

      return data_slots.map do |data_slot|
        required = data_slot.required
        parameters = data_slot.parameters
        filename = data_slot.filename
        extensions = data_slot.extensions

        DataSlot.new(required, parameters, :filename => filename, :extensions => extensions)
      end
    end
  end
end
