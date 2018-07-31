module Api::V1
  class InventionsController < ApplicationController
    expose(:invention)

    def show
      render json: invention.to_json
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end
end
