# frozen_string_literal: true

require 'thor'

require_relative 'updater/analogue/openfpga_service'
require_relative 'updater/github/github_service'
require_relative 'updater/github/repository'
require_relative 'updater/jekyll/jekyll_service'
require_relative 'updater/jekyll/post'
require_relative 'updater/download_helper'
require_relative 'updater/zip_helper'

# Updater CLI
class Updater < Thor
  CORES_FILE = 'cores.yml'

  attr_reader :github_service, :jekyll_service

  class_option :site_path, default: Dir.pwd

  def initialize(args, opts, config)
    super(args, opts, config)

    @github_service = GitHub::GitHubService.new
    @jekyll_service = Jekyll::JekyllService.new(options[:site_path])
  end

  desc 'update', 'Update Analogue Pocket OpenFGPA cores'
  def update
  end
end

Updater.start(ARGV)
