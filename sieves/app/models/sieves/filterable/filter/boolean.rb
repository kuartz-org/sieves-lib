# frozen_string_literal: true

module Sieves
  module Filterable
    class Filter
      class Boolean < Filter
        operator("equal") { arel_column.eq(value_for_sql) }

        def select_options
          [true, false].map! do |boolean|
            [I18n.t("filterable.operators.boolean.#{boolean}"), boolean]
          end
        end

        def needs_select_input?
          true
        end
      end
    end
  end
end
