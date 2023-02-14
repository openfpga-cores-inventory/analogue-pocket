require 'octokit'

require_relative 'resource_filter'

class Repository
  attr_reader :owner, :name, :display_name
  attr_accessor :resource_filter

  def github_repository
    return Octokit::Repository.new("#{owner}/#{name}")
  end

  def initialize(owner, name, display_name)
    @owner = owner
    @name = name
    @display_name = display_name
    @resource_filter = ResourceFilter.new
  end
end
