# frozen_string_literal: true

require 'open-uri'
require 'tempfile'

module Updater
  # Helper class to download files
  class DownloadHelper
    def self.download(url, binmode: false)
      uri = URI.parse(url)

      name = File.basename(uri.path, '.*')
      extension = File.extname(uri.path)
      temp_file = Tempfile.new([name, extension], binmode: binmode)

      uri.open('rb') do |file|
        temp_file.write(file.read)
        temp_file.close
      end

      temp_file
    end
  end
end
