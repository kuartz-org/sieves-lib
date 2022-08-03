# frozen_string_literal: true

module Sieves
  module Filterable
    class Filter
      class Number < Filter
        operator("equal") { arel_column.eq(value_for_sql) }
        operator("not_equal") { arel_column.not_eq(value_for_sql) }
        operator("gt") { arel_column.gt(value_for_sql) }
        operator("gteq") { arel_column.gteq(value_for_sql) }
        operator("lt") { arel_column.lt(value_for_sql) }
        operator("lteq") { arel_column.lteq(value_for_sql) }
        operator("empty") { arel_column.eq(nil) }
        operator("not_empty") { arel_column.not_eq(nil) }
      end
    end
  end
end
