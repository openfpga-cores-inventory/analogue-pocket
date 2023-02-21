module Analogue
  class CoreMetadata
    attr_reader :platform_ids, :shortname, :description, :author, :url, :version, :date_release

    def initialize(platform_ids, shortname, description, author, url, version, date_release)
      @platform_ids = platform_ids
      @shortname = shortname
      @description = description
      @author = author
      @url = url
      @version = version
      @date_release = date_release
    end
  end
end
