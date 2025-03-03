# frozen_string_literal: true

module Inventory
  # Represents an openFPGA repository
  class Source
    attr_reader :repository, :assets, :contents

    def initialize(repository, assets, contents)
      @repository = repository
      @assets = assets
      @contents = contents
    end
  end
end
