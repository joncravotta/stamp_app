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
      context_length = context_verticals.length

      context_verticals.each do |k, v|
        previous_vertical = {}
        if context_count == 0
          hash = {}
          hash[:x] = last_horizontal["startX"]
          hash[:y] = last_horizontal["startY"]
          hash[:width] = v["startX"] - last_horizontal["startX"]
          hash[:height] = v["endY"] - last_horizontal["startY"]
          previous_vertical[:x] = last_horizontal["startX"]
          previous_vertical[:y] = last_horizontal["startY"]
          @formatted_data.push(hash)
        # this is how we know its the last vertical for this horizontals
        elsif context_count == context_length
          hash = {}
          hash[:x] = previous_vertical["x"]
          hash[:y] = previous_vertical["y"]
          hash[:width] = v["startX"] - previous_vertical["x"]
          hash[:height] = v["endY"] - previous_vertical["y"]
          @formatted_data.push(hash)
          last_hash = {}
          hash[:x] = v["startX"]
          hash[:y] = v["startY"]
          hash[:width] = imageWidth - v["startX"]
          hash[:height] = v["endY"] - last_horizontal["y"]
          @formatted_data.push(hash)
        # this is a vertical in between other verticals
        else
          hash = {}
          hash[:x] = previous_vertical["x"]
          hash[:y] = previous_vertical["y"]
          hash[:width] = v["startX"] - previous_vertical["x"]
          hash[:height] = v["endY"] - previous_vertical["y"]
          previous_vertical[:x] = v["startX"]
          previous_vertical[:y] = v["startY"]
          @formatted_data.push(hash)
        end

      end
    end
  end
end
