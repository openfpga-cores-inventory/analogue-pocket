module Analogue
  class Core
    attr_reader :definition, :data

    def id
      return "#{author}.#{shortname}"
    end

    def platform_id
      return @definition.metadata.platform_ids.first
    end

    def shortname
      return @definition.metadata.shortname
    end

    def description
      return @definition.metadata.description
    end

    def author
      return @definition.metadata.author
    end

    def version
      return @definition.metadata.version
    end

    def date_release
      return @definition.metadata.date_release
    end

    def initialize(definition, data)
      @definition = definition
      @data = data
    end
  end
end
