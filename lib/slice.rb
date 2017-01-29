require 'mini_magick'
class Slice
  def initialize(image, slice_data, account_name)
    # removing the datauri and letting image magick figure it out
    # could prob use some nicer regex here
    base64_string = image.gsub!(/.*?(?=,)/im, "")
    base64_string[0] = ''
    @account_name = account_name
    @image = base64_string
    @slice_data = slice_data
    @cropped_urls = []
    slice
  end

  def slice
    @slice_data.each_with_index do |slice, i|
      crop = Crop.new(@image, slice[:x], slice[:y], slice[:width], slice[:height], i, @account_name)
      @cropped_urls.push(crop.upload_url)
    end
  end

  def cropped_urls
    @cropped_urls
  end
end

class Crop
  def initialize(image, x, y, width, height, index, account_name)
    blob = Base64.decode64(image)
    @account_name = account_name
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
    upload = CloudinaryClient.new(@account_name).upload_image(@image.path)
    @upload_url = upload['secure_url']
  end

  def upload_url
    @upload_url
  end
end
