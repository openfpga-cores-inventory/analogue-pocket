require_relative 'front_matter'

module Jekyll
  class Post < FrontMatter
    POST_LAYOUT = 'post'

    attr_reader :date, :categories, :tags

    def initialize(title, date, categories, tags, content)
      super(POST_LAYOUT, title, content)

      @date = date
      @categories = categories
      @tags = tags
    end
  end
end
