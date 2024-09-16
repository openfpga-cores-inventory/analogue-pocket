# frozen_string_literal: true

module GitHub
  # Represents a GitHub content
  class Content
    attr_reader :name, :download_url

    def initialize(name, download_url)
      @name = name
      @download_url = download_url
    end
  end
end
