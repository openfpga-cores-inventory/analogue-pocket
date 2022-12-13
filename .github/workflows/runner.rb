# frozen_string_literal: true

# This is the entrypoint for GitHub Actions.

require_relative "yaml_generator"

$github_token = ARGV[0]
YAMLGenerator.new.call
