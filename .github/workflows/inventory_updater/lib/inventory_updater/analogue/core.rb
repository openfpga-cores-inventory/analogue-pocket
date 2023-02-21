module Analogue
  class Core
    attr_reader :definition, :data

    def id
      return "#{@definition.metadata.author}.#{@definition.metadata.shortname}"
    end

    def platform_id
      return @definition.metadata.platform_ids.first
    end

    def date_release
      return @definition.metadata.date_release
    end

    def version
      return @definition.metadata.version
    end

    def initialize(definition, data)
      @definition = definition
      @data = data
    end
  end
end
