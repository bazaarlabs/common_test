module CommonTest
  module Adapters
    module MiniTest
      def self.install(_manager)
        if Kernel.const_defined?(:MiniTest)
          ::MiniTest::Unit.class_eval do
            # run
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              define_method(:run) do |*args|
                _manager.dispatch_run(self) do
                  _original_run(*args)
                end
              end
            end
          end

          ::MiniTest::Unit::TestCase.class_eval do
            # test
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              define_method(:run) do |*args|
                _manager.dispatch_test(self, [self.__name__]) do
                  _original_run(*args)
                end
              end
            end
          end
          true
        else
          false
        end
      end
    end
  end
end