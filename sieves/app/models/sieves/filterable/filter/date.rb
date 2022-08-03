# frozen_string_literal: true

module Sieves
  module Filterable
    class Filter
      class Date < Filter
        operator("equal") do
          return arel_column.eq(cast_value) unless datetime_column?

          all_day = cast_value
          arel_column.gteq(all_day.begin).and(arel_column.lteq(all_day.end))
        end

        operator("not_equal") do
          return arel_column.not_eq(cast_value) unless datetime_column?

          all_day = cast_value
          arel_column.lt(all_day.begin).or(arel_column.gt(all_day.end))
        end

        operator("gt") { arel_column.gt(cast_value) }
        operator("gteq") { arel_column.gteq(cast_value) }
        operator("lt") { arel_column.lt(cast_value) }
        operator("lteq") { arel_column.lteq(cast_value) }
        operator("empty") { arel_column.eq(nil) }
        operator("not_empty") { arel_column.not_eq(nil) }

        private

        def cast_value
          value = value_for_sql
          cast_value = value.iso8601 unless value.is_a?(::String)
          datetime = Time.zone.parse(cast_value || value)

          column.type == :date ? datetime.to_date : adjust_datetime_value(datetime)
        end

        ##
        # When column is of type `datetime`, value must be adjusted so it returns correct results
        # when filtering with a whole date, without time
        def adjust_datetime_value(datetime)
          case operator
          when "gt", "lteq" then datetime.end_of_day
          when "lt", "gteq" then datetime.beginning_of_day
          when "equal", "not_equal" then datetime.all_day
          else
            datetime
          end
        end

        def datetime_column?
          column.type == :datetime
        end
      end
    end
  end
end
