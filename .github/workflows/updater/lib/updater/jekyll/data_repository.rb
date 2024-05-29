# frozen_string_literal: true

module Jekyll
  # Repository to interact with Jekyll data files
  class DataRepository
    attr_reader :data_path

    def initialize(data_path)
      @data_path = data_path
    end

    def get_data(name)
      path = File.join(@data_path, name)
      File.read(path)
    end

    def write_data(name, content)
      path = File.join(@data_path, name)
      File.write(path, content)
    end
  end
end
