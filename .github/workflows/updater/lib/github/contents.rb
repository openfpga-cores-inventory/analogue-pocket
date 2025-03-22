# frozen_string_literal: true

module GitHub
  # Represents a GitHub content
  class Contents
    attr_reader :name, :download_url

    def initialize(contents)
      @name = contents.name
      @download_url = contents.download_url
    end
  end
end
