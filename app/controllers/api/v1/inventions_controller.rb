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

    # NOTE This does not support creating a new invention using PUT w/ a client-supplied invention.id
    #   We do not want clients deciding what the postgres primary key should be.
    def update
      invention.update!(invention_params)
      render status: :ok, json: invention
    rescue => e
      render status: :unprocessable_entity, json: { error: e.message }
    end

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
      params.permit(:description, :email, :id, :title, :username, bit_ids: [])
    end
  end
end
