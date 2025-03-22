# frozen_string_literal: true

module Inventory
  # Represents a release of a core
  class Release
    LICENSE_DATA_SLOTS = %w[COINOPKEY JTBETA License].freeze

    attr_reader :date, :download_url, :core, :data, :updaters, :info, :requires_license

    def initialize(date, download_url, core, data, updaters, info)
      @date = date
      @download_url = download_url
      @core = core
      @data = data
      @updaters = updaters
      @info = info
      @requires_license = requires_license?
    end

    private

    def requires_license?
      return !@updaters.license.nil? unless @updaters.nil?

      # Fallback to checking with the data slots
      @data.data_slots.any? { |data_slot| LICENSE_DATA_SLOTS.include?(data_slot.name) }
    end
  end
end
