# frozen_string_literal: true

require_relative 'post_repository'

module Jekyll
  # Service to interact with Jekyll
  class JekyllService
    DATA_DIRECTORY = '_data'
    ASSETS_DIRECTORY = 'assets'
    IMAGES_DIRECTORY = 'images'

    attr_reader :site_path, :post_repository

    def initialize(site_path)
      @site_path = site_path
      @post_repository = PostRepository.new(@site_path)
    end

    def data_path
      File.join(@site_path, DATA_DIRECTORY)
    end

    def images_path
      File.join(@site_path, ASSETS_DIRECTORY, IMAGES_DIRECTORY)
    end

    def create_post(title, post)
      @post_repository.create_post(title, post)
    end
  end
end
