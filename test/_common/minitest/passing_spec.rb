require 'minitest/spec'
require 'common_test/auto'

describe "PassingTest" do
  it "should test good" do
    $test += 1
    pass
  end

  it "should test good2" do
    $test +=1
    pass
  end
end
