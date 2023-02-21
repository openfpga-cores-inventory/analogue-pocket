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
      definition = parse_json(core_path)
      return CoreDefinition.new(definition)
    end

    def parse_data(id)
      data_path = File.join(id, DATA_FILE)
      data = parse_json(data_path)
      return CoreData.new(data)
    end
  end
end
