# frozen_string_literal: true

module Sieves
  module Filterable
    class FiltersController < ApplicationController
      before_action :set_model
      before_action :set_filters


      def create
        @filters << @model.filterable.filter_placeholder
        render_form
      end

      def show
        @submit_path = URI.parse(filterable_params[:submit_path]).path
        render_form
      end

      def destroy
        @filters.delete_at(params[:filter_index].to_i)
        render_form
      end

      private

      def set_model
        @model = params[:filterable_model_name].constantize
      end

      def set_filters
        @filters = Filter.parse(@model, filterable_params.fetch(:filters, []))
      end

      def render_form
        respond_to do |format|
          format.turbo_stream { render "filterable/filters/show" }
        end
      end
    end
  end
end
