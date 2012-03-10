require "bundler/gem_tasks"
include Rake::DSL

STDOUT.sync = true

namespace :test do
  desc "Test adapters"
  task :adapters do
    Dir['test/*'].each do |dir|
      if ENV['DIR_TEST']
        File.basename(dir) == ENV['DIR_TEST'] or next
      end
      print "Testing #{dir}"
      Dir.chdir(dir) do
        pid = fork {
          ENV['BUNDLE_GEMFILE'] = './Gemfile'
          if !File.exist?('Gemfile.lock') or ENV['OVERWRITE_LOCKS']
            puts "No lock file exists, running..."
          end
          unless ENV['DEBUG']
            $stdout.reopen("/dev/null")
            $stderr.reopen("/dev/null")
          end
          exec("bundle exec rake --trace")
        }
        _, exitstatus = Process.waitpid2
        raise unless exitstatus.success?
        print " :)\n"
      end
    end
  end
end

desc "Run all tests"
task :test => %w(test:adapters)
