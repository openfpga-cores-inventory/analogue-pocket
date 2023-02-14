module Analogue
  class DefinitionService
    attr_reader :root_path

    def initialize(root_path)
      @root_path = root_path
    end

    def parse_definition(relative_path)
      definition_path = File.join(@root_path, relative_path)
      contents = File.read(definition_path)
      return JSON.parse(contents, object_class: OpenStruct)
    end
  end
end
