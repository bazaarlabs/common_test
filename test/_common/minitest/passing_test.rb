require 'minitest/unit'
require 'common_test/auto'

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
