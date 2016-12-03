require 'cloudinary'
require 'byebug'

class CloudinaryClient
  def initialize
    @api_name = 'dunnw3dw2'
    @api_key = '533599645552823'
    @api_secret = 'BxY7uft7-3mNAiCQuAXma-MacZA'
  end

  def auth
    {
      cloud_name: @api_name,
      api_key:    @api_key,
      api_secret: @api_secret
    }
  end

  def upload_images(images)
    #byebug
    puts images.last.crop
    #images.first.crop.tempfile.open.read
    images.each do |image|
      #accessed_image = image.crop.path
      #upload_image(image.crop.path)
    end
  end

  def upload_image(image)
    upload = Cloudinary::Uploader.upload(image, auth)
    puts upload
    upload
  end
end
