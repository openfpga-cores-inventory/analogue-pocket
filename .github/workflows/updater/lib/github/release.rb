# frozen_string_literal: true

module GitHub
  # Represents a GitHub release
  class Release
    attr_reader :name, :tag_name, :assets

    def initialize(release)
      @name = release.name
      @tag_name = release.tag_name
      @assets = release.assets.map do |asset|
        Asset.new(asset)
      end
    end

    # Represents a GitHub release asset
    class Asset
      attr_reader :name, :browser_download_url, :created_at

      def initialize(asset)
        @name = asset.name
        @browser_download_url = asset.browser_download_url
        @created_at = asset.created_at
      end
    end
  end
end
