# frozen_string_literal: true

source 'https://rubygems.org'
# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
# gem "jekyll", "~> 4.2.2"
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
gem 'github-pages', '~> 232', group: :jekyll_plugins
# If you have any plugins, put them here!
group :jekyll_plugins do
  gem 'jekyll-feed', '~> 0.17.0'
  gem 'jekyll-minifier', '~> 0.1.10'
  gem 'jekyll-paginate', '~> 1.1'
  gem 'jekyll-remote-theme', '~> 0.4.3'
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem 'tzinfo', '~> 1.2'
  gem 'tzinfo-data'
end

# Performance-booster for watching directories on Windows
gem 'wdm', '~> 0.1.1', platforms: %i[mingw x64_mingw mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem 'http_parser.rb', '~> 0.6.0', platforms: [:jruby]

gem 'webrick', '~> 1.9'

gem 'chunky_png', '~> 1.4.0'
gem 'faraday-retry', '~> 2.3.0'
gem 'json-schema', '~> 5.1.1'
gem 'netrc', '~> 0.11.0'
gem 'octokit', '~> 4.25.1'
gem 'rubyzip', '~> 2.4.1'
gem 'slugify', '~> 1.0.7'
gem 'thor', '~> 1.3.1'

group :test, :development do
  gem 'rubocop', '~> 1.74'
end
