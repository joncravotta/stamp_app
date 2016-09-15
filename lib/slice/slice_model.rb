class SliceModel
  def initialize(data)
    @data = data["slice_data"]
    @image_width = data["imageWidth"].to_i
    @image_height = data["imageHeight"].to_i
    @formatted_data = []
    @horizontal = []
    @vertical = []
    parse_slice_data
  end

  # Pushing horizontal and vertical data
  def parse_slice_data
    @data.each do |key, value|
      puts value[:clickType]
      if value[:clickType] == "horizontal"
        @horizontal.push(value)
      else
        @vertical.push(value)
      end
    end
    sort_horizontal
  end

  #sorting horizontal data
  def sort_horizontal

    @horizontal.sort_by { |key, value| key[:startY] }
    puts "sort_horz #{@horizontal}"
    puts @vertical
    create_crops
  end

  def create_crops
    #Last horizontal line x,y is stored here
    last_horizontal = {"startX" => 0, "startY" => 0}

    @horizontal.each do |key, value|
      #getting all verticals that match up with current horizontal
      puts "in side horizontal loop #{key} #{value}"
      context_verticals = []
      # looking for matching verticals
      @vertical.each do |k, v|
        if key["startY"] == k["endY"]
          puts "found match horz vert match. vert = #{k}"
          context_verticals.push(k)
        end
      end

      #printing all found verts
      puts "context vert #{context_verticals}"
      sorted_verts = context_verticals.sort_by { |k, _v| k[:startX] }
      puts "context vert sorted #{sorted_verts}"

      #if context count is 0 then then it is the first vertical and has to get the edges
      context_count = 0
      context_length = context_verticals.length - 1
      previous_vertical = {}

      context_verticals.each do |k, v|
        if context_count == 0
          puts "first block, context_count: #{context_count}, previous vertical: #{previous_vertical}}"
          hash = {}
          hash[:x] = last_horizontal["startX"]
          hash[:y] = last_horizontal["startY"]
          hash[:width] = k["startX"].to_i - last_horizontal["startX"].to_i
          hash[:height] = k["endY"].to_i - last_horizontal["startY"].to_i
          previous_vertical[:x] = k["startX"]
          previous_vertical[:y] = k["startY"]
          @formatted_data.push(hash)
        elsif context_count == context_length
          # this is how we know its the last vertical for this horizontals
          puts "last block, context_count: #{context_count}, previous vertical: #{previous_vertical}"
          hash = {}
          hash[:x] = previous_vertical["x"].to_i
          hash[:y] = previous_vertical["y"].to_i
          hash[:width] = k[:startX].to_i - previous_vertical[:x].to_i
          hash[:height] = k["endY"].to_i - previous_vertical["y"].to_i
          @formatted_data.push(hash)
          last_hash = {}
          hash[:x] = k["startX"].to_i
          hash[:y] = k["startY"].to_i
          hash[:width] = @image_width - k["startX"].to_i
          hash[:height] = k["endY"].to_i - last_horizontal["y"].to_i
          @formatted_data.push(hash)
        else
          # this is a vertical in between other verticals
          puts "middle block, context_count: #{context_count}, previous vertical: #{previous_vertical}"
          hash = {}
          hash[:x] = previous_vertical[:x].to_i
          hash[:y] = previous_vertical[:y].to_i
          hash[:width] = k[:startX].to_i - previous_vertical[:x].to_i
          hash[:height] = k[:endY].to_i - previous_vertical[:y].to_i
          puts "middle block created this hahs #{hash}"
          puts "width calculation is #{k[:startX]} - #{previous_vertical[:x]}"
          puts "which should be equal to #{hash[:width]}"
          @formatted_data.push(hash)
          previous_vertical[:x] = k["startX"]
          previous_vertical[:y] = k["startY"]
        end
        context_count  = context_count + 1
        puts @formatted_data
      end
    end
  end
end
