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

  def sort_horizontal
    puts @horizontal
    @horizontal.sort_by { |key, value| key[:startY] }
    puts @horizontal
    puts @vertical
    create_crops
  end

  def create_crops
    #horizontals are sorted here
    last_horizontal = {"startX" => 0, "startY" => 0}
    @horizontal.each do |key, value|
      puts "horizontal loop #{key} #{value}"
      context_verticals = []
      puts key["startY"]
      @vertical.each do |k, v|
        puts k
        if key["startY"] == k["endY"]
          puts "found match #{key}"

          context_verticals.push(k)
        end
      end
      puts "context vert #{context_verticals}"
      sorted_verts = context_verticals.sort_by { |k, _v| k[:startX] }
      puts "context vert sorted #{sorted_verts}"

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
        # this is how we know its the last vertical for this horizontals
        elsif context_count == context_length
          puts "second block, context_count: #{context_count}, previous vertical: #{previous_vertical}}"
          hash = {}
          hash[:x] = previous_vertical["x"].to_i
          hash[:y] = previous_vertical["y"].to_i
          hash[:width] = k["startX"].to_i - previous_vertical["x"].to_i
          hash[:height] = k["endY"].to_i - previous_vertical["y"].to_i
          @formatted_data.push(hash)
          last_hash = {}
          hash[:x] = k["startX"].to_i
          hash[:y] = k["startY"].to_i
          hash[:width] = @image_width - k["startX"].to_i
          hash[:height] = k["endY"].to_i - last_horizontal["y"].to_i
          @formatted_data.push(hash)
        # this is a vertical in between other verticals
        else
          puts "third block, context_count: #{context_count}, previous vertical: #{previous_vertical}}"
          hash = {}
          hash[:x] = previous_vertical["x"].to_i
          hash[:y] = previous_vertical["y"].to_i
          hash[:width] = k["startX"].to_i - previous_vertical["x"].to_i
          hash[:height] = k["endY"].to_i - previous_vertical["y"].to_i
          previous_vertical[:x] = k["startX"]
          previous_vertical[:y] = k["startY"]
          @formatted_data.push(hash)
        end
        context_count  = context_count + 1
        puts @formatted_data
      end
    end
  end
end
