# frozen_string_literal: true

module GitHub
  # Represents a GitHub asset
  class Asset
    attr_reader :name, :browser_download_url

    def initialize(name, browser_download_url)
      @name = name
      @browser_download_url = browser_download_url
    end
  end
end
