require 'common_test'

module CommonTest
  def self.inject!
    installation_status = Adapters::MiniTest.install || Adapters::RSpec.install
    raise("Cannot determine which suites to inject into...") unless installation_status
  end
end

CommonTest.inject!
