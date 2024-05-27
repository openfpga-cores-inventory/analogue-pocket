# frozen_string_literal: true

module Jekyll
  # Post for Jekyll
  class Post
    LAYOUT = 'post'

    attr_reader :author, :title, :date, :categories, :tags

    def initialize(author, title, date, categories, tags, content)
      @author = author
      @title = title
      @date = date
      @categories = categories
      @tags = tags
      @content = content
    end

    def to_markdown
      <<~MARKDOWN
        ---
        layout: #{LAYOUT}
        author: #{@author}
        title: #{@title}
        date: #{@date}
        categories: [#{@categories.join(', ')}]
        tags: [#{@tags.join(', ')}]
        ---
        #{post.content}
      MARKDOWN
    end
  end
end
