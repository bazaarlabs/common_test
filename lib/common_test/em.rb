module CommonTest
  module EM
    def initialize(opts)
      @time_to_wait = opts && opts[:time_to_wait]
    end

    def on_test(context)
      EventMachine.run do
        if @time_to_wait
          EventMachine.add_timer(@time_to_wait) do
            EventMachine.stop
          end
        end
        context.next
      end
    end
  end
end