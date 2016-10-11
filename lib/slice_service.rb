require_relative "./slice.rb"
require_relative "./slice_model.rb"
require "byebug"

class SliceService
  def initialize(data)
    byebug
    @image = data["image"]
    @slice_data = data
    format_data
  end

  def format_data
    formatted = SliceModel.new(@slice_data)
    slice(formatted.get_formatted_data)
  end

  def slice(formatted_data)
    Slice.new(@image, formatted_data)
  end
end
