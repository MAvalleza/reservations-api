module Api
  module V1
    class GuestsController < ApplicationController
      def index
        @guests = Guest.all

        render json: @guests
      end

      def show
        @guest = Guest.find(params[:id])
  
        render json: @guest
      rescue ActiveRecord::RecordNotFound
        render json: {}
      end
    end
  end
end