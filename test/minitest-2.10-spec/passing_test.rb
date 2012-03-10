require File.expand_path('../test_helper', __FILE__)

describe "PassingTest" do
  before do
    $suite = true
  end

  it "should test good" do
    $test = true
    pass
  end
end
