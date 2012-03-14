module CommonTest
  module Adapters
    module RSpec
      def self.install(_manager)
        if Kernel.const_defined?(:RSpec)
          ::RSpec::Core::Runner.class_eval do
            @@_manager = _manager
            class << self
              # run
              unless method_defined?(:_original_run)
                alias_method :_original_run, :run
                define_method(:run) do |*args|
                  @@_manager.dispatch_run(self, :type => :rspec, :version => VERSION) {
                    _original_run(*args)
                  }
                end
              end
            end
          end

          ::RSpec::Core::Example.class_eval do
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              define_method(:run) do |example_group_instance, *args|
                original_block = @example_block
                @example_block = proc do
                  _manager.dispatch_test(self,
                    [self.class.description, example.metadata[:description]],
                    :type => :rspec, :version => VERSION
                  ) do
                    original_block.call
                  end
                end
                _original_run(example_group_instance, *args)
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