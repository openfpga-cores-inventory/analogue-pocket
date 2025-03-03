# frozen_string_literal: true

module GitHub
  # Represents a GitHub content
  class Commit
    attr_reader :sha

    def initialize(commit)
      @sha = commit.sha
    end
  end
end
