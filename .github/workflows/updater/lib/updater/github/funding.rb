# frozen_string_literal: true

require 'yaml'

module GitHub
  # Funding information for a GitHub repository
  class Funding
    BUY_ME_A_COFFEE = 'buy_me_a_coffee'
    COMMUNITY_BRIDGE = 'community_bridge'
    GITHUB = 'github'
    ISSUEHUNT = 'issuehunt'
    KO_FI = 'ko_fi'
    LIBERAPAY = 'liberapay'
    OPEN_COLLECTIVE = 'open_collective'
    PATREON = 'patreon'
    POLAR = 'polar'
    THANKS_DEV = 'thanks_dev'
    TIDELIFT = 'tidelift'
    CUSTOM = 'custom'

    BUY_ME_A_COFFEE_URL = 'https://buymeacoffee.com'
    COMMUNITY_BRIDGE_URL = 'https://crowdfunding.lfx.linuxfoundation.org/projects'
    GITHUB_URL = 'https://github.com/sponsors'
    ISSUEHUNT_URL = 'https://issuehunt.io/r'
    KO_FI_URL = 'https://ko-fi.com'
    LIBERAPAY_URL = 'https://liberapay.com'
    OPEN_COLLECTIVE_URL = 'https://opencollective.com'
    PATREON_URL = 'https://www.patreon.com'
    POLAR_URL = 'https://polar.sh'
    THANKS_DEV_URL = 'https://thanks.dev'
    TIDELIFT_URL = 'https://tidelift.com/funding/github'

    attr_accessor :buy_me_a_coffee, :community_bridge, :github, :issuehunt, :ko_fi, :liberapay, :open_collective,
                  :patreon, :polar, :tidelift, :custom

    def initialize(funding)
      funding.each do |platform, value|
        next if value.nil?

        parse_platform(platform, value)
      end
    end

    def self.from_file(path)
      funding = YAML.load_file(path)
      Funding.new(funding)
    end

    private

    def parse_platform(platform, value)
      case platform
      when BUY_ME_A_COFFEE then parse_buy_me_a_coffee(value)
      when COMMUNITY_BRIDGE then parse_community_bridge(value)
      when GITHUB then parse_github(value)
      when ISSUEHUNT then parse_issuehunt(value)
      when KO_FI then parse_ko_fi(value)
      when LIBERAPAY then parse_liberapay(value)
      when OPEN_COLLECTIVE then parse_open_collective(value)
      when PATREON then parse_patreon(value)
      when POLAR then parse_polar(value)
      when THANKS_DEV then parse_thanks_dev(value)
      when TIDELIFT then parse_tidelift(value)
      when CUSTOM then parse_custom(value)
      end
    end

    def parse_buy_me_a_coffee(username)
      @buy_me_a_coffee = "#{BUY_ME_A_COFFEE_URL}/#{username}"
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

    def parse_patreon(username)
      @patreon = "#{PATREON_URL}/#{username}"
    end

    def parse_polar(username)
      @polar = "#{POLAR_URL}/#{username}"
    end

    def parse_thanks_dev(username)
      @tidelift = "#{THANKS_DEV_URL}/#{username}"
    end

    def parse_tidelift(platform_package)
      @tidelift = "#{TIDELIFT_URL}/#{platform_package}"
    end

    def parse_custom(urls)
      @custom = urls.is_a?(String) ? [urls] : urls
    end
  end
end
