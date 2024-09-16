# frozen_string_literal: true

require 'yaml'

class CacheService
  CORES_DIRECTORY = 'cores'
  PLATFORMS_DIRECTORY = 'platforms'

  attr_reader :cores_path, :platforms_path

  def initialize(cache_path)
    @cores_path = File.join(cache_path, CORES_DIRECTORY)
    @platforms_path = File.join(cache_path, PLATFORMS_DIRECTORY)
  end

  def get_cores
    get_core_ids.map { |core_id| get_core(core_id) }
  end

  def get_core(core_id)
    path = File.join(@cores_path, "#{core_id}.yml")
    return nil unless File.exist?(path)

    permitted_classes = [
      Analogue::Core,
      Analogue::Core::Metadata,
      Analogue::Core::Framework, Analogue::Core::Framework::Dock, Analogue::Core::Framework::Hardware,
      Analogue::Core::DataSlot, Analogue::Core::DataSlot::Parameters
    ]

    YAML.safe_load_file(path, permitted_classes: permitted_classes)
  end

  def get_platform(platform_id)
    path = File.join(@platforms_path, "#{platform_id}.yml")
    return nil unless File.exist?(path)

    YAML.safe_load_file(path, permitted_classes: [Analogue::Platform])
  end

  private

  def get_core_ids
    Dir.children(@cores_path).map { |file_name| File.basename(file_name, '.yml') }
  end
end
