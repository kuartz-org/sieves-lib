# frozen_string_literal: true

module Sieves
  module Filterable
    class Filter
      class String < Filter
        operator("equal") { arel_column.eq(value_for_sql) }
        operator("not_equal") { arel_column.not_eq(value_for_sql) }
        operator("contains") { arel_column.matches("%#{value_for_sql}%") }
        operator("empty") { arel_column.eq(nil).or(arel_column.eq("")) }
        operator("not_empty") { arel_column.not_eq(nil).and(arel_column.not_eq("")) }

        def operators_options
          super.reject do |(_translation, operator)|
            operator == "contains" if enumerized?
          end
        end

        def select_options
          column.klass.enumerized_attributes[column.name].options
        end

        def needs_select_input?
          enumerized?
        end
      end
    end
  end
end
