require 'rmagick'

class Slice
  def initialize(image, slice_data)
    @image = Magick::ImageList.new("./lib/test_image.jpg")
    @slice_data = slice_data
    # @sliced_image = []
    slice
  end

  def slice
    @slice_data.each_with_index do |slice, i|
      cropped = @image.crop(slice[:x], slice[:y], slice[:width], slice[:height])
      cropped.write("test_cropped#{i}.jpg")
    end
  end
end
