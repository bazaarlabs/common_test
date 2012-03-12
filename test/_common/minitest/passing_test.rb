require 'minitest/unit'
require File.expand_path("../test_helper", __FILE__)

class PassingTest < MiniTest::Unit::TestCase
  def test_good
    $test += 1
    pass
  end

  def test_good2
    $test += 1
    pass
  end
end
