# frozen_string_literal: true

require 'chunky_png'

module Analogue
  # Helper class to export binary data to images
  class ImageHelper
    def self.export(binary_path, width, height, output_path, invert: true)
      bytes = File.open(binary_path, 'rb', &:read).bytes.to_a
      image = ChunkyPNG::Image.new(width, height)

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          index = ((x * height) + y) * 2
          value = bytes[index]
          brightness = invert ? 255 - value : value
          image[width - 1 - x, y] = ChunkyPNG::Color.rgb(brightness, brightness, brightness)
        end
      end

      image.save(output_path)
    end
  end
end
