require_relative "slice/slice.rb"
require_relative "slice/slice_model.rb"

class SliceService
  def initialize(data)
    @image = "test_image.jpg"
    @slice_data = data
    format_data
  end

  def format_data
    formatted = SliceModel.new(@slice_data)
    #slice(formatted)
  end

  def slice(formatted_data)
    Slice.new(@image, formatted_data)
  end
end
