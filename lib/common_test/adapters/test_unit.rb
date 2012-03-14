module CommonTest
  module Adapters
    module TestUnit
      def self.install(_manager)
        if Kernel.const_defined?(:Test) && Test.const_defined?(:Unit)
          ::Test::Unit::AutoRunner.class_eval do
            @@_manager = _manager
            class << self
              # run
              unless method_defined?(:_original_run)
                alias_method :_original_run, :run
                define_method(:run) do |*args|
                  @@_manager.dispatch_run(self, :type => :testunit, :version => VERSION) do
                    _original_run(*args)
                  end
                end
              end
            end
          end

          ::Test::Unit::TestCase.class_eval do
            # test
            unless method_defined?(:_original_run)
              alias_method :_original_run, :run
              define_method(:run) do |*args, &blk|
                _manager.dispatch_test(self, [self.class.to_s, @method_name], :type => :testunit, :version => VERSION) do
                  _original_run(*args, &blk)
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