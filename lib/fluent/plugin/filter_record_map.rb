require 'fluent_plugin_filter_record_map/version'
require 'socket'

module Fluent
  class RecordMapFilter < Filter
    Plugin.register_filter('record_map', self)

    PARAM_INDICES = 1..9

    PARAM_INDICES.each do |i|
      options = (i == 1) ? {} : {:default => nil}
      config_param :"map#{i}", :string, options
    end

    class Context
      def context(tag, record)
        tag_parts = tag.split('.')
        hostname = Socket.gethostname
        new_record = {}
        binding
      end
    end # Context

    def configure(conf)
      super
      @context = Context.new
      @maps = []

      PARAM_INDICES.each do |i|
        expr = instance_variable_get("@map#{i}")
        @maps << expr if expr
      end
    end

    def filter(tag, time, record)
      bind = @context.context(tag, record)

      @maps.each do |expr|
        eval(expr, bind)
      end

      eval('new_record', bind)
    end
  end
end
