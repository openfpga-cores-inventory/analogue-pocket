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

    attr_accessor :github, :patreon, :open_collective, :ko_fi, :tidelift, :community_bridge, :liberapay, :issuehunt, :otechie, :custom

    def self.parse_content(content)
      yml = YAML.load(content)
      funding = Funding.new

      yml.each do |key, value|
        next if value.nil?

        case key
        when COMMUNITY_BRIDGE
          funding.community_bridge = "#{COMMUNITY_BRIDGE_URL}/#{value}"
        when GITHUB
          users = value.is_a?(String) ? [value] : value
          funding.github = users.map { |user| "#{GITHUB_URL}/#{user}" }
        when ISSUEHUNT
          funding.issuehunt = "#{ISSUEHUNT_URL}/#{value}"
        when KO_FI
          funding.ko_fi = "#{KO_FI_URL}/#{value}"
        when LIBERAPAY
          funding.liberapay = "#{LIBERAPAY_URL}/#{value}"
        when OPEN_COLLECTIVE
          funding.open_collective = "#{OPEN_COLLECTIVE_URL}/#{value}"
        when OTECHIE
          funding.otechie = "#{OTECHIE_URL}/#{value}"
        when PATREON
          funding.patreon = "#{PATREON_URL}/#{value}"
        when TIDELIFT
          funding.tidelift = "#{TIDELIFT_URL}/#{value}"
        when CUSTOM
          urls = value.is_a?(String) ? [value] : value
          funding.custom = urls
        end
      end

      return funding
    end
  end
end
