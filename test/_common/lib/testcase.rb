class Testcase
  def run
    reset_state
    CommonTest.on_run do |context|
      $run += 1
      result = context.next
    end
    run_tests
    test_state(1, 2)

    reset_state
    CommonTest.on_run do |context|
      # do nothing this time
    end
    run_tests
    test_state(0, 0)

    reset_state
    CommonTest.on_run do |context|
      $run += 1
      result = context.next
    end
    CommonTest.on_test do |context|
      result = context.next
    end
    run_tests
    test_state(1, 2)

    reset_state
    CommonTest.on_run do |context|
      $run += 1
      result = context.next
    end
    CommonTest.on_test do |context|
      if context.name =~ /good2/
        result = context.next
      end
    end
    run_tests
    test_state(1, 1)
  end

  def test_state(*states)
    raise "weird number of states" unless states.size == 2
    [$run, $test] == states or
      raise "Excepted #{states.inspect}, got #{[$run, $test].inspect}"
  end

  def reset_state
    CommonTest.reset!
    $run, $test = 0, 0
  end
end

class MinitestTestcase < Testcase
  def run_tests
    MiniTest::Unit.new.run
  end

  def reset_state
    super
    MiniTest::Unit.runner = nil
  end
end

class RSpecTestcase < Testcase
  def run_tests
    RSpec::Core::Runner.run []
  end

  def reset_state
    super
    RSpec.reset
    load File.expand_path('../../rspec/passing_test.rb', __FILE__)
  end
end
