module Analogue
  class Core
    attr_reader :description, :data

    def initialize(description, data)
      @description = description
      @data = data
    end

    def platform_id
      return @description.metadata.platform_ids.first
    end
  end
end
