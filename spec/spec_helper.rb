$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fluent/test'
require 'fluent/plugin/filter_record_map'
require 'time'

# Disable Test::Unit
module Test::Unit::RunCount; def run(*); end; end

RSpec.configure do |config|
  config.before(:all) do
    Fluent::Test.setup
  end
end

def create_driver(options = {})
  fluentd_conf = <<-EOS
type object_flatten
map #{options.fetch(:map)}
  EOS

  tag = options[:tag] || 'test.default'
  Fluent::Test::FilterTestDriver.new(Fluent::RecordMapFilter, tag).configure(fluentd_conf)
end
