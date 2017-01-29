class Pricing
  BIRDY=1
  FLOCK=2
  NEST=3

  def initialize(pricing_type)
    @pricing_type = pricing_type
  end

  def get_price
    case @pricing_type
    when 1
      228
    when 2
      348
    when 3
      468
    else
      ""
    end
  end

  def get_seat_count
    case @pricing_type
    when 1
      1
    when 2
      3
    when 3
      5
    else
      ""
    end
  end

  def get_email_count
    case @pricing_type
    when 1
      100
    when 2
      250
    when 3
      500
    else
      ""
    end
  end

  def get_sub_id
    case @pricing_type
    when 1
      ""
    when 2
      ""
    when 3
      ""
    else
      ""
    end
  end
end
