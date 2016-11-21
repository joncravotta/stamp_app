require "byebug"
class SliceModel
  def initialize(data)
    @data = data["slice_data"]
    @image_width = data["imageWidth"]
    @image_height = data["imageHeight"]
    @formatted_data = []
    @horizontal = []
    @vertical = []
    parse_slice_data
  end

  # 1. PARSING DATA
  def parse_slice_data
    if @data.nil?
      @formatted_data.push({ :x => 0, :y => 0, :width => @image_width, :height => @image_height })
    else
      @data.each do |key, value|
        if value[:clickType] == "horizontal"
          @horizontal.push(value)
        else
          @vertical.push(value)
        end
      end
      sort_horizontal
    end
  end

  #SORTING HORIZONTALS
  def sort_horizontal
    @horizontal = @horizontal.sort_by { |key, value| key[:startY] }
    # INSERTING LAST LINE AS HORIZONTAL
    @horizontal.push({"clickType"=>"horizontal", "startX"=>"0", "startY"=> @image_height, "endX"=>@image_width, "endY"=>@image_height})
    create_crops
  end

  def create_crops
    #PERVIOUS horizontal line x,y is stored here
    prev_horizontal_y = 0

    #looping through each sorted horizontal line
    @horizontal.each do |key, value|
      # getting all verticals that match up with current horizontal
      # CONTEXT VERTICALS ARE VERTICAL THAT ARE IN CURRENT HORIZONTAL
      context_verticals = []
      @vertical.each do |k, v|
        if key["startY"] == k["endY"]
          puts "found match horz vert match. vert = #{k}"
          context_verticals.push(k)
        end
      end
      puts "context verticals #{context_verticals} \n"
      # Not sorting properly
      sorted_verts = context_verticals.sort_by { |k| k[:startX].to_i }
      puts "context vert sorted #{sorted_verts} \n"

      # inserting left edge of verticals
      # appending right edge of verticals
      sorted_verts.push({"clickType" => "vertical", "startX" => @image_width, "startY" => prev_horizontal_y, "endX" => @image_width, "endY" => key["startY"]})
      puts "sorted after adding: #{sorted_verts}"
      # if context count is 0 then then it is the first vertical and has to get the edges
      context_count = 0
      context_length = context_verticals.length - 1
      previous_vertical_x = 0
      previous_vertical_y = prev_horizontal_y

      sorted_verts.each do |k, v|
        # this is a vertical in between other verticals
        puts "middle block, context_count: #{context_count}, previous verticalx: #{previous_vertical_x} previous vertical_y #{previous_vertical_y}\n"
        hash = {}
        hash[:x] = previous_vertical_x
        hash[:y] = previous_vertical_y
        hash[:width] = k['startX'].to_i - previous_vertical_x
        hash[:height] = (k['endY'].to_i - previous_vertical_y).abs #needs to be positive
        puts "middle block created this hash #{hash} \n"
        puts "width calculation is #{k[:startX]} - #{previous_vertical_x} \n"
        puts "which should be equal to #{hash[:width]} \n"
        previous_vertical_x = k["startX"].to_i
        previous_vertical_y = k["startY"].to_i
        @formatted_data.push(hash)
      end

      prev_horizontal_y = key["startY"].to_i
    end
  end

  # Should use an accessor instead of this
  def get_formatted_data
    @formatted_data
  end

end
