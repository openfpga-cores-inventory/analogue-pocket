module Analogue
  class DefinitionService
    attr_reader :root_path

    def initialize(root_path)
      @root_path = root_path
    end

    def parse_file(relative_path)
      path = File.join(@root_path, relative_path)
      return File.read(path)
    end

    def parse_json(relative_path)
      json = parse_file(relative_path)
      return JSON.parse(json, object_class: OpenStruct)
    end
  end
end
