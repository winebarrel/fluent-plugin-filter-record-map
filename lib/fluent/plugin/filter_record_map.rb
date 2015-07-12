require 'fluent_plugin_filter_record_map/version'

module Fluent
  class RecordMapFilter < Filter
    class Context
      def context(tag, record)
        tag_parts = tag.split('.')
        new_record = {}
        binding
      end
    end

    Plugin.register_filter('record_map', self)

    config_param :map, :string

    def configure(conf)
      super
      @context = Context.new
    end

    def filter(tag, time, record)
      bind = @context.context(tag, record)
      eval(@map, bind)
      eval('new_record', bind)
    end
  end
end
