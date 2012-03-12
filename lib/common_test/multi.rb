module CommonTest
  class Multi
    def initialize(number_of_cores)
      @number_of_cores = number_of_cores
    end

    def on_run(context)
      $core_num = nil
      @pids = @number_of_cores.times.map do |i|
        fork do
          $core_num = i
          context.next
          exit
        end
      end
      at_exit do
        @pids.each do |pid|
          Process.kill("INT", pid)
        end
      end
      success = false
      @pids.each do |pid|
        Process.waitpid2(pid)
      end
    end

    def on_test(context)
      if !$core_num.nil? && context.name.hash % @number_of_cores == $core_num
        context.next
      end
    end
  end
end