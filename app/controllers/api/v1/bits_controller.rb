module Api::V1
  class BitsController < ApplicationController
    # Serializer or other gem would be overkill here
    def index
      render json: Bit.all.map { |b| { id: b.id, name: b.name } }
    end
  end
end
