class Source
  attr_reader :repository, :options

  def initialize(repository, options = {})
    @repository = repository
    @options = options
  end
end
