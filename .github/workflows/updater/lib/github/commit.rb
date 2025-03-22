# frozen_string_literal: true

module GitHub
  # Represents a GitHub content
  class Commit
    attr_reader :sha, :commit

    def initialize(commit)
      @sha = commit.sha
      @commit = Commit.new(commit.commit)
    end

    class Commit
      attr_reader :author

      def initialize(commit)
        @author = Author.new(commit.author)
      end

      class Author
        attr_reader :date

        def initialize(author)
          @date = author.date
        end
      end
    end
  end
end
