require "byebug"
class SliceModel
  CropHash = Struct.new(:x, :y, :width, :height)

  def initialize(data)
    @data = data["slice_data"]
    @image_width = data["imageWidth"].to_i
    @image_height = data["imageHeight"].to_i
    @formatted_data = []
    @horizontal = []
    @vertical = []
    parse_slice_data
  end

  # 1. PARSING DATA
  def parse_slice_data
    if @data.nil?
      #didnt want any slices so leave as is
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
    @horizontal.sort_by! { |key, value| key[:startY].to_i }
    # INSERTING LAST LINE AS HORIZONTAL
    @horizontal.push({"clickType"=>"horizontal", "startX"=>"0", "startY"=> @image_height, "endX"=>@image_width, "endY"=>@image_height})
    horizontal_crop_manager
  end

  def horizontal_crop_manager
    prev_horizontal_y = 0
    @horizontal.each do |key, value|

      current_horizontal_y = key["startY"]
      context_verticals = find_context_verticals(current_horizontal_y)

      if context_verticals.length == 0
        # hash = {}
        # hash[:x] = 0
        # hash[:y] = prev_horizontal_y.to_i
        # hash[:width] = @imageWidth
        # hash[:height] = key['endY'].to_i - prev_horizontal_y
        empty_horizontal = CropHash.new(0, prev_horizontal_y.to_i, @image_width, key['endY'].to_i - prev_horizontal_y)
        @formatted_data.push(empty_horizontal)
        prev_horizontal_y = key['endY'].to_i
      else
        #sort verticals

        sorted_verticals = sort_verticals(context_verticals)
        vertical_crop_manager(sorted_verticals, prev_horizontal_y)
        prev_horizontal_y = key['endY'].to_i
        #and then send to build proper cuts
      end
    end
  end

  def vertical_crop_manager(sorted_verticals, horizontal_y)
    # each vertical here should have the same endY, im getting the first one to ad to the right edge
    context_vertical_end_y = sorted_verticals.first['endY'].to_i
    right_edge = {"clickType"=>"vertical", "startX"=>@image_width, "startY"=> horizontal_y, "endX"=>@image_width, "endY"=>context_vertical_end_y}
    sorted_verticals.push(right_edge)

    previous_vertical_x = 0

    sorted_verticals.each do |key, value|

      hash = {}
      vertical_slice = CropHash.new(previous_vertical_x, horizontal_y, key['endX'].to_i - previous_vertical_x, key['endY'].to_i - horizontal_y)
      @formatted_data.push(vertical_slice)
      previous_vertical_x = key['endX'].to_i
    end
  end

  def find_context_verticals(horizontal_y)
    context_verticals = []
    @vertical.each do |k, _|
      current_vertical_end_y = k['endY']

      if horizontal_y == current_vertical_end_y
        puts "found match horz vert match. vert = #{k}"
        context_verticals.push(k)
      end
    end

    context_verticals
  end

  def sort_verticals(unsorted_verticals)
    unsorted_verticals.sort_by! { |k| k[:startX].to_i }
  end

  def create_crops
    #PERVIOUS horizontal line x,y is stored here
    prev_horizontal_y = 0
    #looping through each sorted horizontal line
    @horizontal.each do |key, value|
      # getting all verticals that match up with current horizontal
      # CONTEXT VERTICALS ARE VERTICAL THAT ARE IN CURRENT HORIZONTAL
      current_horizontal_y = key["startY"]
      context_verticals = []
      @vertical.each do |k, v|
        current_vertical_end_y = k["endY"]
        if current_horizontal_y == current_vertical_end_y
          puts "found match horz vert match. vert = #{k}"
          context_verticals.push(k)
        end
      end

      if context_verticals.length == 0

      end
      puts "context verticals #{context_verticals} \n"
      # Not sorting properly
      sorted_verts = context_verticals.sort_by { |k| k[:startX].to_i }
      puts "context vertical sorted left to right #{sorted_verts} \n"

      # appending right edge of verticals
      # this to me does not make sense to add
      #sorted_verts.push({"clickType" => "vertical", "startX" => @image_width, "startY" => prev_horizontal_y, "endX" => @image_width, "endY" => key["startY"]})
      puts "sorted after adding: #{sorted_verts}"
      # context count is for logging
      context_count = 0
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
