# frozen_string_literal: true

module Inventory
  # Represents a core and its releases
  class Core
    attr_reader :id, :repository, :funding, :releases

    def initialize(id, repository, funding)
      @id = id
      @repository = repository
      @funding = funding
      @releases = []
    end

    def add_release(release)
      return if release_exists?(release.download_url)

      @releases.push(release)
      @releases.sort_by! { |r| r.core.metadata.date_release }
    end

    def release_exists?(download_url)
      @releases.any? { |r| r.download_url == download_url }
    end
  end
end
