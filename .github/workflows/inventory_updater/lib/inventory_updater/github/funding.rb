require 'yaml'

module GitHub
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

    COMMUNITY_BRIDGE_URL = 'https://funding.communitybridge.org/projects'
    GITHUB_URL = 'https://github.com/sponsors'
    ISSUEHUNT_URL = 'https://issuehunt.io/r'
    KO_FI_URL = 'https://ko-fi.com'
    LIBERAPAY_URL = 'https://liberapay.com'
    OPEN_COLLECTIVE_URL = 'https://opencollective.com'
    OTECHIE_URL = 'https://otechie.com'
    PATREON_URL = 'https://www.patreon.com'
    TIDELIFT_URL = 'https://tidelift.com/funding/github'

    attr_accessor :funding, :github, :patreon, :open_collective, :ko_fi, :tidelift, :community_bridge, :liberapay, :issuehunt, :otechie, :custom

    def initialize(funding)
      @funding = funding

      funding.each do |key, value|
        next if value.nil?

        case key
        when COMMUNITY_BRIDGE
          @community_bridge = "#{COMMUNITY_BRIDGE_URL}/#{value}"
        when GITHUB
          users = value.is_a?(String) ? [value] : value
          @github = users.map { |user| "#{GITHUB_URL}/#{user}" }
        when ISSUEHUNT
          @issuehunt = "#{ISSUEHUNT_URL}/#{value}"
        when KO_FI
          @ko_fi = "#{KO_FI_URL}/#{value}"
        when LIBERAPAY
          @liberapay = "#{LIBERAPAY_URL}/#{value}"
        when OPEN_COLLECTIVE
          @open_collective = "#{OPEN_COLLECTIVE_URL}/#{value}"
        when OTECHIE
          @otechie = "#{OTECHIE_URL}/#{value}"
        when PATREON
          @patreon = "#{PATREON_URL}/#{value}"
        when TIDELIFT
          @tidelift = "#{TIDELIFT_URL}/#{value}"
        when CUSTOM
          urls = value.is_a?(String) ? [value] : value
          @custom = urls
        end
      end
    end

    def self.parse_content(content)
      funding = YAML.load(content)
      return Funding.new(funding)
    end
  end
end
