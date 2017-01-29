require 'minitest/autorun'
require_relative '../../lib/pricing.rb'

class PricingTest < MiniTest::Unit::TestCase
  def setup
    @birdy = Pricing.new(Pricing::BIRDY)
    @flock = Pricing.new(Pricing::FLOCK)
    @nest  = Pricing.new(Pricing::NEST)
  end

  def test_plan_price
    assert_equal 228, @birdy.get_price
    assert_equal 348, @flock.get_price
    assert_equal 468, @nest.get_price
  end

  def test_seat_count
    assert_equal 1, @birdy.get_seat_count
    assert_equal 3, @flock.get_seat_count
    assert_equal 5, @nest.get_seat_count
  end

  def test_email_count
    assert_equal 100, @birdy.get_email_count
    assert_equal 250, @flock.get_email_count
    assert_equal 500, @nest.get_email_count
  end

  def teat_sub_id
    assert_equal "", @birdy.get_sub_id
    assert_equal "", @flock.get_sub_id
    assert_equal "", @nest.get_sub_id
  end
end
