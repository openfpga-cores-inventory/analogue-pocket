# frozen_string_literal: true

module GitHub
  # Represents a GitHub release
  class Release
    attr_reader :assets

    def initialize(assets)
      @assets = assets
    end
  end
end
