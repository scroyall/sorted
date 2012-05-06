require 'action_view'
require 'sorted'

module Sorted
  module ViewHelpers
    module ActionView
      class SortedViewHelper
        attr_reader :params

        def initialize(order, params)
          sort = params.delete :sort
          @params = params
          @parser = ::Sorted::Parser.new(sort, order).toggle
          @params[:sort] = @parser.to_s
        end

        def css
          if @parser.sorts.flatten.include? @parser.orders[0][0]
            "sorted #{@parser.sorts.assoc(@parser.orders[0][0]).last}"
          else
            "sorted"
          end
        end
      end

      def link_to_sorted(*args, &block)
        if block_given?
          name = capture(&block)
          order = args.first
          options = args.second || {}
        else
          name = args[0]
          order = args[1]
          options = args[2] || {}
        end

        sorter          = SortedViewHelper.new(order, ((request.get? && !params.nil?) ? params.dup : {}))
        options[:class] = [options[:class], sorter.css].join(' ').strip
        link_to(name.to_s, sorter.params, options)        
      end
    end
  end
end
