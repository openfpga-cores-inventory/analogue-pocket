module Analogue
  class CoreMetadata
    attr_reader :metadata, :platform_ids, :shortname, :description, :author, :url, :version, :date_release

    def initialize(metadata)
      @metadata = metadata

      @platform_ids = metadata.platform_ids
      @shortname = metadata.shortname
      @description = metadata.description
      @author = metadata.author
      @url = metadata.url
      @version = metadata.version
      @date_release = metadata.date_release
    end
  end
end
