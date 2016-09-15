require 'rmagick'

class Slice
  def initialize(image, slice_data)
    @image = Magick::Image.read(image)[0]
    @slice_data = slice_data
    # @sliced_image = []
    slice
  end

  def slice
    image_number = 0
    # @slice_data.each do |slice|
    #   cropped = @image.crop(slice.x, slice.y, slice.width, slice.height)
    #   @sliced_image.push(cropped)
    # end
    cropped = @image.crop(100, 100, 100, 100)
    cropped.write("test_cropped.jpg")
  end
end
