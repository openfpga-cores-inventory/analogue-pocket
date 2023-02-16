module Analogue
  class Core
    attr_reader :definition, :data

    def initialize(definition, data)
      @definition = definition
      @data = data
    end

    def platform_id
      return @definition.metadata.platform_ids.first
    end
  end
end
