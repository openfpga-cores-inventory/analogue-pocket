require_relative 'core_metadata'

module Analogue
  class CoreDefinition
    attr_reader :core, :metadata

    def initialize(core)
      @core = core
      @metadata = CoreMetadata.new(core.core.metadata)
    end
  end
end
