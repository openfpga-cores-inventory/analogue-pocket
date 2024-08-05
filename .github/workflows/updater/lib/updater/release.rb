# frozen_string_literal: true

# Release class
class Release
  attr_reader :download_url, :repository

  def initialize(download_url, repository)
    @download_url = download_url
    @repository = repository
  end
end
