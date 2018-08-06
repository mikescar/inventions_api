require 'rails_helper'

RSpec.describe 'unmatched routes', type: :request do
  let(:error_hash) { { error: 'Not found' }.to_json }

  describe 'favicon' do
    before { get '/favicon.ico' }

    it { expect(response.status).to eq 404 }
    it { expect(response.body).to eq error_hash }
  end

  describe 'api routes' do
    describe 'api/v1/inventions#index' do
      before { get '/api/v1/inventions' }

      it { expect(response.status).to eq 404 }
      it { expect(response.body).to eq error_hash }
    end
  end
end
