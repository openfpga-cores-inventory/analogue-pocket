# frozen_string_literal: true

# Definition for an openFPGA core repository
class CoreRepository
  attr_reader :owner, :name, :display_name, :options

  def initialize(owner, name, display_name, options = {})
    @owner = owner
    @name = name
    @display_name = display_name
    @options = options
  end
end
