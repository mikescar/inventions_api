require 'rails_helper'

RSpec.describe Api::V1::BitsController, type: :controller do
  let(:bit1) { Bit.create!(name: 'yeller') }
  let(:bit2) { Bit.create!(name: 'green') }

  describe '#index' do
    it 'returns empty array if no bits defined' do
      get :index
      expect(response.body).to eq [].to_json
    end

    it 'returns array of bit hashes' do
      expected_response = [{ id: bit1.id, name: bit1.name }, { id: bit2.id, name: bit2.name}]

      get :index
      expect(response.body).to eq expected_response.to_json
    end
  end

  # If we like to be explicit that these routes should not be opened by accident, implement for CRUD ops also
  describe '#show' do
    let(:call) { get :show, params: { id: bit1.id } }

    it 'should throw error' do
      expect { call }.to raise_error(ActionController::UrlGenerationError, /No route matches.*/)

      # expect(response.status).to eq 404
    end
  end
end
