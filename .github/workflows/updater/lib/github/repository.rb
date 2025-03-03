# frozen_string_literal: true

module GitHub
  # Represents a GitHub repository
  class Repository
    attr_reader :name, :owner, :html_url

    def initialize(repository)
      @name = repository.name
      @owner = Owner.new(repository.owner)
      @html_url = repository.html_url
    end

    def slug
      "#{@owner.login}/#{@name}"
    end

    # Represents a GitHub repository owner
    class Owner
      attr_reader :login

      def initialize(owner)
        @login = owner.login
      end
    end
  end
end
