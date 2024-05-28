# frozen_string_literal: true

require_relative 'post_repository'
require_relative 'data_repository'

module Jekyll
  # Service to interact with Jekyll
  class JekyllService
    DATA_DIRECTORY = '_data'

    attr_reader :site_path, :data_repository, :post_repository

    def initialize(site_path)
      @site_path = site_path

      data_path = File.join(@site_path, DATA_DIRECTORY)
      @data_repository = DataRepository.new(data_path)
      @post_repository = PostRepository.new(@site_path)
    end

    def create_post(title, post)
      @post_repository.create_post(title, post)
    end

    def get_data(name)
      @data_repository.get_data(name)
    end

    def write_data(name, content)
      @data_repository.write_data(name, content)
    end
  end
end
