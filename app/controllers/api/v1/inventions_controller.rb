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
    # TODO Add handling for records that user is unauthorized to delete
    #   I like 404 for this case also, to avoid leaking info about which IDs are valid.
    def destroy
      invention.destroy!
    rescue ActiveRecord::RecordNotFound => e
      render status: :not_found, json: { error: e.message }
    rescue => e
      render status: :unprocessable_entity, json: { error: e.message }
    end

    private

    def invention_params
      params.permit(:description, :email, :id, :title, :username, bit_ids: [], materials: [])
    end
  end
end
