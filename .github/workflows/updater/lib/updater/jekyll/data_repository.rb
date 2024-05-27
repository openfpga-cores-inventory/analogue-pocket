# frozen_string_literal: true

require 'yaml'

module Updater
  class DataRepository
    attr_reader :data_path

    def initialize(data_path)
      @data_path = data_path
    end

    def get_data(data)
      path = File.join(@data_path, "#{data}.yml")
      YAML.load_file(path)
    end

    def write_data(data, content)
      path = File.join(@data_path, "#{data}.yml")
      File.write(path, content.to_yaml)
    end
  end
end
