require_relative "./slice.rb"
require_relative "./slice_model.rb"
require_relative "./cloudinary_client.rb"

class SliceService
  def initialize(data)
    @image = data["image"]
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
    response_json(slices.cropped_urls)
  end

  def response_json(images)
    @hash[:urls] = images
  end

  def url_hash
    @hash
  end
end
