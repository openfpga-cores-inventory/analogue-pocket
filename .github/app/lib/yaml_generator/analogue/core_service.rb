require_relative 'core'
require_relative 'core_data'
require_relative 'core_description'
require_relative 'core_metadata'
require_relative 'data_slot'
require_relative 'definition_service'

module Analogue
  class CoreService < DefinitionService
    CORES_DIRECTORY = 'Cores'

    CORE_FILE = 'core.json'
    DATA_FILE = 'data.json'

    def initialize(root_path)
      super(File.join(root_path, CORES_DIRECTORY))
    end

    def get_core(identifier)
      description = parse_description(identifier)
      data = parse_data(identifier)

      return Core.new(description, data)
    end

    private

    def parse_description(identifier)
      core_path = File.join(identifier, CORE_FILE)
      definition = parse_definition(core_path)

      metadata = parse_metadata(definition)

      return CoreDescription.new(metadata)
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
