module CommonTest
  module Adapters
    module RSpec
      def self.install(manager)
        if Kernel.const_defined?(:RSpec)
          ::RSpec::Core::Runner.class_eval do
            class << self
              # run
              unless method_defined?(:_original_run)
                alias_method :_original_run, :run
                def run(*args)
                  CommonTest.instance.dispatch_run(self) {
                    _original_run(*args)
                  }
                end
              end
            end
          end

          ::RSpec::Core::Example.class_eval do
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              def run(*args)
                original_block = @example_block
                @example_block = proc do
                  CommonTest.instance.dispatch_test([@description], :instance => self) do
                    original_block.call
                  end
                end
                _original_run(*args)
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