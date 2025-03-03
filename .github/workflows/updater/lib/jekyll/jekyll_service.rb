# frozen_string_literal: true

require 'slugify'

module Jekyll
  class JekyllService
    ASSETS_DIRECTORY = 'assets'
    IMAGES_DIRECTORY = 'images'
    DATA_DIRECTORY = '_data'
    POSTS_DIRECTORY = '_posts'

    attr_reader :site_path, :data_path, :images_path

    def initialize(site_path)
      @site_path = site_path
      @data_path = File.join(site_path, DATA_DIRECTORY)
      @posts_path = File.join(site_path, POSTS_DIRECTORY)
      @images_path = File.join(site_path, ASSETS_DIRECTORY, IMAGES_DIRECTORY)
    end

    def create_post(title, post)
      date = Date.parse(post.date) || Time.now
      post_file = "#{date.strftime('%Y-%m-%d')}-#{title.slugify}.md"
      post_path = File.join(@posts_path, post_file)
      FileUtils.mkdir_p(File.dirname(post_path))
      File.open(post_path, 'w') { |file| file.write(post.to_markdown) }
    end
  end
end
