require "common_test/version"
require "common_test/registration"
require "common_test/dispatching"
require "common_test/manager"
require "common_test/adapters/mini_test"
require "common_test/adapters/rspec"
require "common_test/em"
require "common_test/mute"

module CommonTest
  extend Registration
  extend Dispatching
end
