module Analogue
  class DefinitionService
    attr_reader :root_path

    def initialize(root_path)
      @root_path = root_path
    end

    def parse_json(relative_path)
      path = File.join(@root_path, relative_path)
      json = File.read(path)
      return JSON.parse(json, object_class: OpenStruct)
    end
  end
end
