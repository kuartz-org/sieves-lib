# frozen_string_literal: true

module Sieves
  module Filterable
    class Column
      attr_reader :name, :type, :input_formatter, :label_method, :select_scope, :associated_from

      delegate :operators, to: :filter_class

      def initialize(name, filterable, **options)
        options.assert_valid_keys(:input_formatter, :label_method, :select_scope, :associated_from)
        @name = name.to_s.freeze
        @filterable = filterable
        @input_formatter = options[:input_formatter]
        @label_method = options[:label_method]
        @select_scope = options[:select_scope]
        @associated_from = options[:associated_from]
        set_type
      end

      def filter_class
        FILTERS_REGISTRY[type]
      end

      def format_value(value)
        return value unless input_formatter && value.present?

        input_formatter.call(value)
      end

      def association?
        filterable.model.reflect_on_association(name).present?
      end

      def association_class
        return unless association?

        @association_class ||= begin
          reflection = filterable.model.reflect_on_association(name)

          reflection.klass
        end
      end

      def association_name
        if association?
          name.to_sym
        elsif associated_column?
          associated_from
        end
      end

      def enumerized?
        return false unless defined?(Enumerize) && klass.respond_to?(:enumerize)

        klass.enumerized_attributes[name].present?
      end

      def associated_column?
        @associated_from.present?
      end

      def klass
        @klass ||=
          if associated_column?
            reflection = filterable.model.reflect_on_association(associated_from)

            unless reflection
              raise(ArgumentError, "association '#{associated_from}' does not exist on #{filterable.model.name}")
            end

            reflection.klass
          else
            filterable.model
          end
      end

      private

      attr_reader :filterable

      def set_type
        return @type = :association if association?

        column = klass.column_for_attribute(name)

        unless column.type
          raise(ArgumentError, "column or association '#{name}' does not exist on #{filterable.model.name}")
        end

        unless FILTERS_REGISTRY.key?(column.type)
          raise(ArgumentError, "the type '#{column.type}' is not supported for column '#{name}'")
        end

        @type = column.type
      end

      def associated_column
        klass.column_for_attribute(name)
      end
    end
  end
end
