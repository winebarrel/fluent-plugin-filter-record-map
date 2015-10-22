$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fluent/test'
require 'fluent/plugin/filter_record_map'
require 'time'
require 'timecop'

# Disable Test::Unit
module Test::Unit::RunCount; def run(*); end; end
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)

RSpec.configure do |config|
  config.before(:all) do
    Fluent::Test.setup
  end
end

def create_driver(options = {})
  tag = options.delete(:tag) || 'test.default'

  fluentd_conf = <<-EOS
type object_flatten
  EOS

  options.each do |key, value|
    fluentd_conf << <<-EOS
#{key} #{value}
    EOS
  end

  Fluent::Test::FilterTestDriver.new(Fluent::RecordMapFilter, tag).configure(fluentd_conf)
end
