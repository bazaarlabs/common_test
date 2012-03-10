module CommonTest
  module Dispatching
    def dispatch_run(*args, &blk)
      return unless CommonTest.instance.dispatch_run?
      CommonTest.instance.dispatch_run(*args, &blk)
    end

    def dispatch_suite(*args, &blk)
      return unless CommonTest.instance.dispatch_suite?
      CommonTest.instance.dispatch_suite(*args, &blk)
    end

    def dispatch_test(*args, &blk)
      return unless CommonTest.instance.dispatch_test?
      CommonTest.instance.dispatch_test(ids, opts, &blk)
    end
  end
end
