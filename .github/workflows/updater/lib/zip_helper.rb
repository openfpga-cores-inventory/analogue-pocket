# frozen_string_literal: true

require 'tmpdir'
require 'zip'

# Helper class to extract zip files
class ZipHelper
  def self.extract(path)
    name = File.basename(path, '.*')

    temp_directory = Dir.mktmpdir(name)
    Zip::File.open(path) do |zip|
      zip.each do |file|
        file_path = File.join(temp_directory, file.name)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip.extract(file, file_path) unless File.exist?(file_path)
      end
    end

    temp_directory
  end
end
