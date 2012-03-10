module CommonTest
  module Adapters
    module MiniTest
      def self.install
        if Kernel.const_defined?(:MiniTest)
          ::MiniTest::Unit.class_eval do
            # run
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              def run(args = [])
                CommonTest.instance.dispatch_run(self) {
                  _original_run(args)
                }
              end
            end
          end

          ::MiniTest::Unit::TestCase.class_eval do
            # suite
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              def run(runner)
                CommonTest.instance.dispatch_suite(self.__name__, :instance => self) {
                  _original_run(runner)
                }
              end
            end

            # test
            unless method_defined?(:_original_run_test)
              alias_method :_original_run_test, :run_test
              def run_test(name)
                CommonTest.instance.dispatch_test(name, :instance => self) {
                  _original_run_test(name)
                }
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