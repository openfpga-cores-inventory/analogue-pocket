# frozen_string_literal: true

module Inventory
  # Represents a core and its releases
  class Core
    attr_reader :id, :repository, :releases
    attr_writer :funding

    def initialize(id, repository)
      @id = id
      @repository = repository
      @releases = []
    end

    def add_release(release)
      return if release_exists?(release.download_url)

      @releases.push(release)
      @releases.sort_by!(&:date)
    end

    def release_exists?(download_url)
      @releases.any? { |r| r.download_url == download_url }
    end
  end
end
