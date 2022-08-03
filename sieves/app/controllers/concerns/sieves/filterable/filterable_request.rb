# frozen_string_literal: true

module Sieves
  module Filterable
    module FilterableRequest
      extend ActiveSupport::Concern

      def filterable(model_or_base_relation)
        model, base_relation =
          if model_or_base_relation.is_a? ActiveRecord::Relation
            [model_or_base_relation.model, model_or_base_relation]
          else
            [model_or_base_relation, model_or_base_relation.all]
          end

        return base_relation if params[:filterable].blank?

        model.filter(filterable_params, base_relation: base_relation)
      end

      def filterable_params
        return {} if params[:filterable].blank?

        params.require(:filterable).permit(
          :conjonction,
          :submit_path,
          sort: {},
          filters: [:column_name, :operator, :value]
        )
      end

      included do
        helper_method :filterable_params
      end
    end
  end
end
