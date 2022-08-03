# frozen_string_literal: true

module Sieves
  module Filterable
    extend ActiveSupport::Concern

    FILTERS_REGISTRY = {
      string: Filter::String,
      integer: Filter::Number,
      float: Filter::Number,
      date: Filter::Date,
      datetime: Filter::Date,
      association: Filter::Association,
      boolean: Filter::Boolean
    }.with_indifferent_access.freeze

    def self.btn_classes
      "btn btn-secondary"
    end

    def self.btn_active_classes
      "bg-neutral-100 font-semibold"
    end

    class_methods do
      attr_reader :filterable

      def filterable(&block)
        if block
          @filterable = Base.new(self)
          @filterable.instance_exec(&block)
        else
          @filterable
        end

      rescue ActiveRecord::ActiveRecordError => e
        Rails.logger.error("\e[0;31mFilterable can't be configure because of an ActiveRecord error: \n\n#{e}\n\e[0m")
      end

      def filter(payload, base_relation: all)
        filters_payload = payload.fetch(:filters, [])
        conjonction = payload.fetch(:conjonction, :and)
        result = FilterSet.from_payload(self, filters_payload, conjonction, base_relation).execute

        sanitized_sort = payload[:sort]&.then do |sort|
          column_name, order = sort.to_h.entries.first
          { column_name => order } if valid_sort?(column_name, order)
        end
        result.order(sanitized_sort)
      end

      private

      def valid_sort?(column_name, order)
        column_name.to_s.in?(column_names) && order.in?(%w[asc desc])
      end
    end
  end
end
