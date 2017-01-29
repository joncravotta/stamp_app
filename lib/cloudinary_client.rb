require 'cloudinary'

class CloudinaryClient
  def initialize(company_name)
    @company_name = company_name
    @api_name = 'dunnw3dw2'
    @api_key = '533599645552823'
    @api_secret = 'BxY7uft7-3mNAiCQuAXma-MacZA'
  end

  def auth
    {
      cloud_name: @api_name,
      api_key:    @api_key,
      api_secret: @api_secret,
      folder: "#{@company_name}/"
    }
  end

  def upload_images(images)
    images.each do |image|
      #accessed_image = image.crop.path
      #upload_image(image.crop.path)
    end
  end

  def upload_image(image)
    upload = Cloudinary::Uploader.upload(image, auth)
    upload
  end
end
