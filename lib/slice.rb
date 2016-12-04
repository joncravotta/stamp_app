require 'mini_magick'
require 'byebug'
class Slice
  def initialize(image, slice_data)
    @image = image
    @slice_data = slice_data
    @cropped_urls = []
    slice
  end

  def slice
    puts "The slice struct #{@slice_data}"
    @slice_data.each_with_index do |slice, i|
      puts slice
      crop = Crop.new(@image, slice[:x], slice[:y], slice[:width], slice[:height], i)
      @cropped_urls.push(crop.upload_url)
    end
  end

  def cropped_urls
    @cropped_urls
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
    @upload_url = ''
    crop_upload
  end

  def crop_upload
    @image.crop("#{@width}x#{@height}+#{@x}+#{@y}")
    upload = CloudinaryClient.new.upload_image(@image.path)
    @upload_url = upload['secure_url']
  end

  def upload_url
    @upload_url
  end
end
