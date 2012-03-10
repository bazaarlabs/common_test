module CommonTest
  module EM
    def initialize(opts)
      @time_to_wait = opts && opts[:time_to_wait]
    end

    def on_test(context)
      ::EM.run do
        EM.add_timer(@time_to_wait) { EM.stop } if @time_to_wait
        context.next
      end
    end
  end
end