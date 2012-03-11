module CommonTest
  module Registration
    def use(register, *args, &blk)
      Manager.instance.use(register, *args, &blk)
    end

    def on_run(&blk)
      Manager.instance.on_run(&blk)
    end

    def on_test(&blk)
      Manager.instance.on_test(&blk)
    end
  end
end
