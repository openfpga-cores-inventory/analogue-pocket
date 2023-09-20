require 'chunky_png'

class BinaryImage
  def self.convert_image(path, width, height, invert = true)
    bytes = File.open(path, 'rb') { |file| file.read }.bytes.to_a

    image = ChunkyPNG::Image.new(width, height)

    index = 0
    x = width

    while x >= 0
      y = 0
      while y < height
        value = bytes[index]
        brightness = invert ? 255 - value : value

        image[x,y] = ChunkyPNG::Color.rgb(brightness, brightness, brightness)

        y += 1
        index += 2
      end
      x -= 1
    end

    return image
  end
end
