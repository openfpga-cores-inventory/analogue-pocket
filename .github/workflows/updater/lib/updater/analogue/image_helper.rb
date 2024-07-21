# frozen_string_literal: true

require 'chunky_png'

module Analogue
  # Helper class to export binary data to images
  class ImageHelper
    def self.export(binary_path, width, height, output_path, invert: true)
      # Read the brightness values from the binary file
      bytes = File.binread(binary_path)

      # Unpack the bytes into their brightness values
      brightness = bytes.unpack('s*')

      # Convert the brightness values to their RGB representation
      rgb_brightness = brightness.flat_map { |value| [invert ? 255 - value : value] * 3 }

      # Pack the RGB values into a byte stream
      bytes = rgb_brightness.pack('C*')

      # Create a new image with the specified width and height
      rotated_image = ChunkyPNG::Image.from_rgb_stream(height, width, bytes)

      # Rotate the image 90 degrees clockwise
      image = rotated_image.rotate_right

      image.save(output_path)
    end
  end
end
