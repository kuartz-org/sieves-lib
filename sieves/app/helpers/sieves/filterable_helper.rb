# frozen_string_literal: true

module Sieves
  module FilterableHelper
    def filterable_active_filters?
      params[:filterable].present? && filterable_params[:filters].present?
    end

    def filterable_form_for(model)
      filters =
        if filterable_active_filters?
          Filterable::Filter.parse(model, filterable_params.fetch(:filters, []))
        else
          []
        end

      render "filterable/filters/wrapper" do
        render "filterable/filters/form", filters: filters,
                                          filterable: model.filterable,
                                          submit_path: URI.parse(request.fullpath).path
      end
    end

    def filterable_input_classes
      <<-TXT
        w-full min-w-fit block shadow-sm border-gray-300 rounded-md
        focus:ring-primary-500 focus:border-primary-500
        sm:text-sm
      TXT
    end

    def filterable_value_input(form, filter, index)
      input_name = "filterable[filters][][value]"
      input_options = { class: filterable_input_classes, data: { value_input_index: index } }
      input_options.merge!(style: "display: none;", disabled: true) unless filter.needs_input?

      if filter.type.in?([:date, :datetime])
        input_options[:value] = filter.value&.to_date
        form.date_field input_name, input_options
      elsif filter.needs_select_input?
        form.select input_name, filter.select_options, { selected: filter.value }, input_options
      else
        input_options[:value] = filter.value
        form.text_field input_name, input_options
      end
    end

    def filterable_sort_button(model, column)
      return yield unless column.to_s.in?(model.column_names)

      form_id = model.filterable.form_id
      icon_fa_class = filterable_sort_icon(column)
      content_tag(:div, nil, {
                    class: "h-full cursor-pointer flex justify-between",
                    data: {
                      controller: "filterable-sort",
                      filterable_sort_form_id_value: form_id,
                      filterable_sort_column_name_value: column,
                      action: "click->filterable-sort#sortColumn"
                    }
                  }) do
        concat yield
        concat content_tag(:i, nil, class: "ml-2 fas fa-fw #{icon_fa_class}")
      end
    end

    def current_sort_input(form)
      return unless (current_sort = filterable_params[:sort])

      column_name, order = current_sort.to_h.entries.first
      form.hidden_field "filterable[sort][#{column_name}]",
                        value: order,
                        data: { column_name: column_name },
                        id: "filterable_sort"
    end

    def filterable_sort_icon(column)
      current_sort = filterable_params[:sort]
      column_name, order = current_sort.to_h.entries.first if current_sort
      return "fa-sort" unless current_sort && column_name == column.to_s

      order == "asc" ? "fa-sort-down" : "fa-sort-up"
    end
  end
end
