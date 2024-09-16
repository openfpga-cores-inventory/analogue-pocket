# frozen_string_literal: true

# Release class
class Release
  attr_reader :download_url, :repository, :funding

  def initialize(download_url, repository, funding)
    @download_url = download_url
    @repository = repository
    @funding = funding
  end
end
