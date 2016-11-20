require 'mini_magick'

class Slice
  def initialize(image, slice_data)
    @image = image
    @slice_data = slice_data
    slice
  end

  def slice
    @slice_data.each_with_index do |slice, i|
      puts slice
      Crop.new(@image, slice[:x], slice[:y], slice[:width], slice[:height], i)
    end
  end
end

class Crop
  def initialize(image, x, y, width, height, index)
    metadata = "data:image/jpeg;base64,"
    base64_string = image[metadata.size..-1]
    blob = Base64.decode64(base64_string)
    @image = MiniMagick::Image.read(blob)
    @x = x
    @y = y
    @width = width
    @height = height
    @index = index
    crop
  end

  def crop
    @image.crop("#{@width}x#{@height}+#{@x}+#{@y}")
    @image.write("test_cropped#{@index}.jpg")
  end
end
