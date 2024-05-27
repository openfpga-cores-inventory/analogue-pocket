# frozen_string_literal: true

module GitHub
  # Defines a GitHub repository
  class Repository
    attr_reader :owner, :name

    def initialize(owner, name)
      @owner = owner
      @name = name
    end
  end
end
