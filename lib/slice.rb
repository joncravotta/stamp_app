require 'mini_magick'

class Slice
  def initialize(image, slice_data)
    metadata = "data:image/jpeg;base64,"
    base64_string = image[metadata.size..-1]
    blob = Base64.decode64(base64_string)
    @image = MiniMagick::Image.read(blob)
    @slice_data = slice_data
    # @sliced_image = []
    slice
  end

  def slice
    @slice_data.each_with_index do |slice, i|
      #cropped = @image.crop(slice[:x], slice[:y], slice[:width], slice[:height])
      cropped = @image.crop('100x200')
      cropped.write("test_cropped#{i}.jpg")
    end
  end
end
