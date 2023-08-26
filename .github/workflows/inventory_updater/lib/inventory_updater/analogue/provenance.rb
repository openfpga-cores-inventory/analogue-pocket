module Analogue
  class Provenance
    attr_reader :provenance, :author, :platform_id, :shortname

    def id
      return "#{@author}.#{@shortname}"
    end

    def initialize(provenance)
      @provenance = provenance

      @author = provenance.author
      @platform_id = provenance.platform_id
      @shortname = provenance.shortname
    end
  end
end
