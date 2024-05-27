# frozen_string_literal: true

module Jekyll
  # Repository for interacting with Jekyll posts
  class PostRepository
    POSTS_DIRECOTRY = '_posts'

    attr_reader :site_path

    def initialize(site_path)
      @site_path = site_path
    end

    def create_post(title, post)
      date = post.date.strftime('%Y-%m-%d')
      post_file = "#{date}-#{title}.md"
      path = File.join(@site_path, post.categories, POSTS_DIRECOTRY, post_file)
      File.open(path, 'w') { |file| file.write(post.to_markdown) }
    end
  end
end
