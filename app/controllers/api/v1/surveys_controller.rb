module Api
  module V1
    class SurveysController < APIApplicationController
      load_resource :only => :index
      authorize_resource

      def index
        @surveys ||= []
        render :json => @surveys.select(&:published?)
      end

      def show
        survey = Survey.find_by_id(params[:id])
        if survey
          render :json => survey.to_json
        else
          render :nothing => true, :status => :bad_request
        end
      end

      def update
        survey = Survey.find_by_id(params[:id])
        if survey && survey.update_attributes(params[:survey])
          render :json => survey.to_json
        else
          render :json => survey.try(:errors).try(:full_messages), :status => :bad_request
        end
      end
    end
  end
end
