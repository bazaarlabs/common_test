require 'common_test'

module CommonTest
  def self.inject!(manager = Manager.instance)
    installation_status ||= Adapters::MiniTest.install(manager)
    installation_status ||= Adapters::RSpec.install(manager)
    installation_status ||= Adapters::TestUnit.install(manager)
    raise("Cannot determine which suites to inject into...") unless installation_status
  end
end

CommonTest.inject!
