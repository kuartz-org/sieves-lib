# frozen_string_literal: true

module Sieves
  module Filterable
    class Filter
      class Association < Filter
        operator("equal") { arel_column.eq(value) }
        operator("not_equal") { arel_column.not_eq(value) }
        operator("empty") { arel_column.eq(nil) }
        operator("not_empty") { arel_column.not_eq(nil) }

        def arel_column
          klass = column.association_class

          klass.arel_table[klass.primary_key]
        end

        def select_options
          klass = column.association_class

          relation.map do |record|
            [record.public_send(column.label_method), record.public_send(klass.primary_key)]
          end
        end

        def needs_select_input?
          true
        end

        private

        def relation
          return column.association_class.all unless column.select_scope

          case column.select_scope
          when Symbol
            column.association_class.instance_eval(&column.select_scope)
          when Proc
            column.association_class.instance_exec(&column.select_scope)
          end
        end
      end
    end
  end
end
