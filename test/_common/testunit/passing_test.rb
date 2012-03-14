require File.expand_path('../test_helper', __FILE__)

class PassingTest < Test::Unit::TestCase
  def test_good
    $test += 1
    assert true
  end

  def test_good2
    $test += 1
    assert true
  end
end
