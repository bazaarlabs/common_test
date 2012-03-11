# CommonTest

Have you ever wanted to inject some piece of code into your tests, or have a library that adds some sort of common behaviour to various test suites? CommonTest aims to add a common interface that can be used to inject a piece of functionality across multiple test suites.

## Currently supported test suites

* Minitest 2.10, 2.11
* RSpec 2.8

## Usage

To load CommonTest, add

    gem 'common_test', '~> 0.0.1'

Then, require your gem:

    require 'minitest' # or require 'rspec'
    require 'common_test/auto'

    CommonTest.on_test do |context|
      context.next if context.name =~ /my_test/
    end

## Interface

CommonTest gives you three points of injection; at the entire test run level and per-test.

To use it on the test run level, use:

    CommonTest.on_run do |context|
      # ...
    end

To use it on the per-test level, use:

    CommonTest.on_test do |context|
      # ...
    end

You can call into the next test by calling `.next` on the context object.
