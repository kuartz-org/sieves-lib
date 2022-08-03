# frozen_string_literal: true

module Sieves
  module Filterable
    class Base
      attr_reader :model

      delegate :all, :arel_table, to: :model

      def initialize(model)
        @model = model
        @columns = []
      end

      def columns(*column_names)
        return @columns unless column_names.any?

        column_names.each do |column_name|
          @columns << Column.new(column_name, self)
        end
      end

      def column(column_name, input_formatter: nil)
        @columns << Column.new(column_name, self, input_formatter: input_formatter)
      end

      def association(column_name, label_method:, select_scope: nil)
        @columns << Column.new(column_name, self, label_method: label_method, select_scope: select_scope)
      end

      def associated_column(column_name, from:, input_formatter: nil)
        @columns << Column.new(column_name, self, associated_from: from, input_formatter: input_formatter)
      end

      def column_names
        columns.map(&:name)
      end

      def columns_for_select
        columns.map do |column|
          [model.human_attribute_name(column.name), column.name]
        end
      end

      def filter_placeholder
        column = columns.first

        column.filter_class.new(column, column.operators.keys.first, nil)
      end

      def form_id
        "filterable_form_#{model.name.underscore}"
      end

      def turbo_frame_id
        "filterable_turbo_frame_#{model.name.underscore}"
      end
    end
  end
end
