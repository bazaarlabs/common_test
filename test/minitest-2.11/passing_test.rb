require File.expand_path('../test_helper', __FILE__)

class PassingTest < MiniTest::Unit::TestCase
  def setup
    $suite = true
  end

  def test_good
    $test = true
    pass
  end
end
