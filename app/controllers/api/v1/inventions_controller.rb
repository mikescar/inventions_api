module Api::V1
  class InventionsController < ApplicationController
    expose(:invention)

    def show
      render json: invention.to_json
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end

    def create
      invention = Invention.create!(invention_params)
      render status: :created, json: invention
    rescue => e
      render status: :unprocessable_entity, json: { error: e.message }
    end

    # TODO implement w/ support for both PUT and PATCH semantics
    def update; end

    # TODO implement soft delete, I hate deleting user data outright.
    # TODO Add handling for records not found, or that user is unauthorized to delete
    #   I like 404 for both cases, since it doesn't leak info about which IDs are valid outside of a user's own objects.
    def destroy
      invention.destroy!
    rescue => e
      render status: :unproccessable_entity, json: { error: e.message }
    end

    private

    def invention_params
      params.permit(:description, :email, :title, :username, bit_ids: [])
    end
  end
end
