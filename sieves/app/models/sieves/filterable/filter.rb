# frozen_string_literal: true

module Sieves
  module Filterable
    class Filter
      INPUT_LESS_OPERATORS = %w[empty not_empty].freeze

      attr_reader :column, :operator, :value

      delegate :operators, :operators_options, to: :class
      delegate :type, :association_name, :association?, :enumerized?, :associated_column?, to: :column

      def initialize(column, operator, value)
        @column = column
        @operator = operator.to_s.freeze
        @value = value
      end

      def arel_condition
        builder = operators[operator] || raise(ArgumentError, "unsupported operator '#{operator}'")

        instance_exec(&builder)
      end

      def needs_input?
        !operator.to_s.in?(INPUT_LESS_OPERATORS)
      end

      def self.operator(param_name, &arel_builder)
        operators[param_name.to_s.freeze] = arel_builder
      end

      def self.operators
        @operators ||= {}
      end

      def self.operators_options
        type_name = name.demodulize.underscore

        operators.each_key.map do |operator|
          [I18n.t("filterable.operators.#{type_name}.#{operator}"), operator]
        end
      end

      def self.parse(model, filters_payload)
        filters_payload.filter_map do |filter_payload|
          column = model.filterable.columns.find do |filterable_column|
            filterable_column.name == filter_payload[:column_name]
          end

          next unless column

          column.filter_class.new(column, *filter_payload.values_at(:operator, :value))
        end
      end

      def value_for_sql
        column.format_value(value)
      end

      def needs_select_input?
        false
      end

      private

      def arel_column
        column.klass.arel_table[column.name]
      end
    end
  end
end
