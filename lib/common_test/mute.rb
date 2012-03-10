module CommonTest
  class Mute
    def on_run(context)
      child = fork {
        $stdout.reopen('/dev/null') # silence all
        $stderr.reopen('/dev/null')
        context.next
      }
      _, status = Process.waitpid2(child)
      exit(status.exitstatus)
    end
  end
end