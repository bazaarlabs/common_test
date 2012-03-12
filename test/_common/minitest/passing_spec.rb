require 'minitest/spec'
require File.expand_path("../test_helper", __FILE__)

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
