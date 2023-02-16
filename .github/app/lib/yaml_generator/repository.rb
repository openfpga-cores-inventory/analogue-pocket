require 'octokit'

require_relative 'resource_filter'

class Repository
  attr_reader :owner, :name, :display_name
  attr_accessor :resource_filter, :prerelease

  def initialize(owner, name, display_name)
    @owner = owner
    @name = name
    @display_name = display_name
    @prerelease = false
    @resource_filter = ResourceFilter.new
  end

  def github_repository
    return Octokit::Repository.new("#{owner}/#{name}")
  end
end
