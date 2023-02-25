require_relative 'front_matter'

module Jekyll
  class Post < FrontMatter
    POST_LAYOUT = 'post'

    attr_reader :date, :categories

    def initialize(title, date, categories, content)
      super(POST_LAYOUT, title, content)

      @date = date
      @categories = categories
    end
  end
end
