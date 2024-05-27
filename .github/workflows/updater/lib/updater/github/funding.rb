# frozen_string_literal: true

require 'yaml'

module GitHub
  # Funding information for a GitHub repository
  class Funding
    COMMUNITY_BRIDGE = 'community_bridge'
    GITHUB = 'github'
    ISSUEHUNT = 'issuehunt'
    KO_FI = 'ko_fi'
    LIBERAPAY = 'liberapay'
    OPEN_COLLECTIVE = 'open_collective'
    OTECHIE = 'otechie'
    PATREON = 'patreon'
    TIDELIFT = 'tidelift'
    CUSTOM = 'custom'

    COMMUNITY_BRIDGE_URL = 'https://crowdfunding.lfx.linuxfoundation.org/projects'
    GITHUB_URL = 'https://github.com/sponsors'
    ISSUEHUNT_URL = 'https://issuehunt.io/r'
    KO_FI_URL = 'https://ko-fi.com'
    LIBERAPAY_URL = 'https://liberapay.com'
    OPEN_COLLECTIVE_URL = 'https://opencollective.com'
    OTECHIE_URL = 'https://otechie.com'
    PATREON_URL = 'https://www.patreon.com'
    TIDELIFT_URL = 'https://tidelift.com/funding/github'

    attr_accessor :github, :patreon, :open_collective, :ko_fi, :tidelift, :community_bridge, :liberapay, :issuehunt,
                  :otechie, :custom

    def initialize(funding)
      funding.each do |sponsor, value|
        next if value.nil?

        parse_sponsor(sponsor, value)
      end
    end

    def self.from_yaml(content)
      funding = YAML.safe_load(content)
      Funding.new(funding)
    end

    private

    def parse_sponsor(sponsor, value)
      case sponsor
      when COMMUNITY_BRIDGE then parse_community_bridge(value)
      when GITHUB then parse_github(value)
      when ISSUEHUNT then parse_issuehunt(value)
      when KO_FI then parse_ko_fi(value)
      when LIBERAPAY then parse_liberapay(value)
      when OPEN_COLLECTIVE then parse_open_collective(value)
      when OTECHIE then parse_otechie(value)
      when PATREON then parse_patreon(value)
      when TIDELIFT then parse_tidelift(value)
      when CUSTOM then parse_custom(value)
      end
    end

    def parse_community_bridge(project_name)
      @community_bridge = "#{COMMUNITY_BRIDGE_URL}/#{project_name}"
    end

    def parse_github(value)
      usernames = value.is_a?(String) ? [value] : value
      @github = usernames.map { |username| "#{GITHUB_URL}/#{username}" }
    end

    def parse_issuehunt(username)
      @issuehunt = "#{ISSUEHUNT_URL}/#{username}"
    end

    def parse_ko_fi(username)
      @ko_fi = "#{KO_FI_URL}/#{username}"
    end

    def parse_liberapay(username)
      @liberapay = "#{LIBERAPAY_URL}/#{username}"
    end

    def parse_open_collective(username)
      @open_collective = "#{OPEN_COLLECTIVE_URL}/#{username}"
    end

    def parse_otechie(username)
      @otechie = "#{OTECHIE_URL}/#{username}"
    end

    def parse_patreon(username)
      @patreon = "#{PATREON_URL}/#{username}"
    end

    def parse_tidelift(platform_package)
      @tidelift = "#{TIDELIFT_URL}/#{platform_package}"
    end

    def parse_custom(urls)
      @custom = value.is_a?(String) ? [urls] : urls
    end
  end
end
