module Jekyll
  class FrontMatter
    attr_reader :layout, :title, :content

    def initialize(layout, title, content)
      @layout = layout
      @title = title
      @content = content
    end
  end
end
