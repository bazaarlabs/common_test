module CommonTest
  class Manager
    module Context
      attr_reader :instance

      def next
        @next.call
      end

      def on_next(&blk)
        @next = blk
      end

      def execute(&blk)
        instance.instance_exec(self, &blk)
      end
    end

    class RunContext
      include Context

      def initialize(instance, opts)
        @instance = instance
      end
    end

    class TestContext
      include Context
      attr_reader :ids

      def initialize(instance, ids, opts)
        @instance, @ids = instance, ids
        @ids = ids
      end

      def name
        @ids.join(" ")
      end
    end

    def self.instance
      @instance ||= Manager.new
    end

    def initialize
      reset!
    end
  
    def reset!
      @run_hooks = []
      @test_hooks = []
    end      

    def use(cls, *args, &blk)
      listener = cls.new(*args, &blk)
      on_run   listener.method(:on_run)   if listener.respond_to?(:on_run)
      on_test  listener.method(:on_test)  if listener.respond_to?(:on_test)
    end

    def on_run(hook = nil, &blk)
      @run_hooks << (hook || blk)
    end

    def on_test(hook = nil, &blk)
      @test_hooks << (hook || blk)
    end

    def dispatch_run(obj, opts = nil, &blk)
      i = 0
      run_context = RunContext.new(obj, opts)
      run_context.on_next do
        if i < @run_hooks.size
          i += 1
          obj.instance_exec(run_context, &@run_hooks.at(i - 1))
        else
          yield
        end
      end
      run_context.next
    end

    def dispatch_test(obj, name, opts = nil, &blk)
      i = 0
      test_context = TestContext.new(obj, name, opts)
      test_context.on_next do
        if i < @test_hooks.size
          i += 1
          test_context.execute(&@test_hooks.at(i - 1))
        else
          yield
        end
      end
      test_context.next
    end
  end

  def self.reset!
    Manager.instance.reset!
  end
end