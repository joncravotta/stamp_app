require 'rmagick'

class Slice
  def initialize(image, slice_data)
    @image = Magick::ImageList.new(image)
    @slice_data = slice_data
    @sliced_image = []
    slice
  end

  def slice
    @slice_data.each_with_index do |slice, i|
      cropped = @image.crop(slice[:x], slice[:y], slice[:width], slice[:height])
      @sliced_image.push(cropped)
      cropped.write("test_cropped#{i}.jpg")
    end
    # return array of slices
    @sliced_image
  end
end
