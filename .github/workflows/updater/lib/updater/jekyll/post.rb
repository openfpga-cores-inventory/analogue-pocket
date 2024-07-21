# frozen_string_literal: true

require 'slugify'

module Jekyll
  # Post for Jekyll
  class Post
    LAYOUT = 'post'

    attr_reader :author, :title, :date, :categories, :tags

    def initialize(author, title, date, categories, tags, content)
      @author = author
      @title = title
      @date = date
      # TODO: Remove this in Jekyll 4.1 in favor of 'slugified_categories' - https://jekyllrb.com/docs/permalinks/#placeholders
      @categories = categories.map(&:slugify)
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
        #{@content}
      MARKDOWN
    end
  end
end
