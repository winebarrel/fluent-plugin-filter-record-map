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

    def filter_stream(tag, es)
      result_es = Fluent::MultiEventStream.new

      es.each do |time, record|
        bind = @context.context(tag, record)
        eval(@map, bind)
        new_record = eval('new_record', bind)
        result_es.add(time, new_record)
      end

      result_es
    rescue => e
      log.warn e.message
      log.warn e.backtrace.join(', ')
    end
  end
end
