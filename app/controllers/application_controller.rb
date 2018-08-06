class ApplicationController < ActionController::API
  def handle_404
   render status: :not_found, json: { error: 'Not found' }
  end
end
