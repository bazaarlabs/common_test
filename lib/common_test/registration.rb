module CommonTest
  module Registration
    def use(register, *args, &blk)
      CommonTest.instance.use(register, *args, &blk)
    end

    def on_run(&blk)
      CommonTest.instance.on_run(&blk)
    end

    def on_suite(&blk)
      CommonTest.instance.on_suite(&blk)
    end

    def on_test(&blk)
      CommonTest.instance.on_test(&blk)
    end
  end

  class Register
    module Context
      def next
        @next.call
      end

      def on_next(&blk)
        @next = blk
      end
    end

    class SuiteContext
      include Context
      attr_reader :name, :instance

      def initialize(name, opts)
        @name = name
        @instance = opts && opts[:instance]
      end
    end

    class RunContext
      include Context
      attr_reader :runner

      def initialize(runner, opts)
        @runner = runner
      end
    end

    class TestContext
      include Context
      attr_reader :ids

      def initialize(ids, opts)
        @ids = ids
        @instance = opts && opts[:instance]
      end
    end

    def initialize
      @run_hooks = []
      @suite_hooks = []
      @test_hooks = []
    end
  
    def use(cls, *args, &blk)
      listener = cls.new(*args, &blk)
      on_run   listener.method(:on_run)   if listener.respond_to?(:on_run)
      on_suite listener.method(:on_suite) if listener.respond_to?(:on_suite)
      on_test  listener.method(:on_test)  if listener.respond_to?(:on_test)
    end

    def on_run(hook = nil, &blk)
      @run_hooks << (hook || blk)
    end

    def on_suite(hook = nil, &blk)
      @suite_hooks << (hook || blk)
    end

    def on_test(hook = nil, &blk)
      @test_hooks << (hook || blk)
    end

    def dispatch_run(runner, opts = nil, &blk)
      i = 0
      run_context = RunContext.new(runner, opts)
      run_context.on_next do
        if i < @run_hooks.size
          i += 1
          @run_hooks.at(i - 1).call(run_context)
        else
          yield
        end
      end
      run_context.next
    end

    def dispatch_suite(name, opts = nil, &blk)
      i = 0
      suite_context = SuiteContext.new(name, opts)
      suite_context.on_next do
        if i < @suite_hooks.size
          i += 1
          @suite_hooks.at(i - 1).call(suite_context)
        else
          yield
        end
      end
      suite_context.next
    end

    def dispatch_test(name, opts = nil, &blk)
      i = 0
      test_context = TestContext.new(name, opts)
      test_context.on_next do
        if i < @test_hooks.size
          i += 1
          @test_hooks.at(i - 1).call(test_context)
        else
          yield
        end
      end
      test_context.next
    end
  end

  def self.instance
    @instance ||= Register.new
  end

  def self.reset!
    @instance = nil
  end
end
