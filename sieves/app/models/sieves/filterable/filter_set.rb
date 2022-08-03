# frozen_string_literal: true

module Sieves
  module Filterable
    class FilterSet
      attr_reader :filters, :conjonction, :model, :base_relation

      delegate :filterable, to: :model

      def initialize(filters, conjonction, model, base_relation = model.all)
        @filters = filters
        @conjonction = conjonction
        @model = model
        @base_relation = base_relation
      end

      def execute
        return base_relation unless filters.any?

        base_relation = self.base_relation
        filters.each do |filter|
          next unless filter.association? || filter.associated_column?

          base_relation = base_relation.left_joins(filter.association_name)
        end

        base_relation.where(conditions)
      end

      def conditions
        conditions_chain = filters.shift.arel_condition

        filters.each do |filter|
          conditions_chain = conditions_chain.public_send(conjonction, filter.arel_condition)
        end

        conditions_chain
      end

      def self.from_payload(model, filters_payload, conjonction, base_relation = model.all)
        filters = Filter.parse(model, filters_payload)

        new(filters, conjonction, model, base_relation)
      end
    end
  end
end
