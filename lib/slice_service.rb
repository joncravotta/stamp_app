require_relative "./slice.rb"
require_relative "./slice_model.rb"
require_relative "./cloudinary_client.rb"

class SliceService
  def initialize(data)
    @image = data["image"]
    @email_width = data["imageWidth"]
    @email_name = data["emailName"]
    @user_id = data["userId"]
    @slice_data = data
    @hash = {}
    format_data
  end

  def format_data
    formatted = SliceModel.new(@slice_data)
    slice(formatted.get_formatted_data)
  end

  def slice(formatted_data)
    slices = Slice.new(@image, formatted_data)
    #TODO lower email count here!
    create_template_in_db(slices.cropped_urls)
  end

  def create_template_in_db(images)
    template = Template.new(user_id: @user_id, name: @email_name, images: images, completed: false, email_width: @email_width)
    if template.save
      response_json(images, template.id)
    else
      @hash[:error] = "ERROR creating template"
    end
  end

  def response_json(images, template_id)
    @hash[:urls] = images
    @hash[:template_id] = template_id
  end

  def url_hash
    @hash
  end
end
