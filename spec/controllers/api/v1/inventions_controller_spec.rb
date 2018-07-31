require 'rails_helper'

RSpec.describe Api::V1::InventionsController, type: :controller do
  # TODO fabricator gem is good replacement for this boilerplate
  let(:bit1) { Bit.create!(name: Faker::Name.name) }
  let(:bit2) { Bit.create!(name: Faker::Name.name) }
  let(:invention) do
    Invention.create!(title: Faker::Name.name, description: Faker::Lorem.sentence, bits: [bit1, bit2])
  end

  let(:parsed_response_body) { JSON.parse(response.body) }

  describe '#index' do
    it 'is not allowed' do
      expect { get :index }.to raise_error(ActionController::UrlGenerationError, /No route matches.*/)
    end
  end

  describe '#show' do
    before { invention }

    context 'with valid :id' do
      before { get :show, params: { id: invention.id } }

      it { expect(parsed_response_body).to be_a Hash }
      it { expect(parsed_response_body['title']).to eq invention.title }
      it { expect(parsed_response_body['description']).to eq invention.description }
    end

    context 'with invalid :id' do
      before { get :show, params: { id: invention.id * 30 } }

      it { expect(response.status).to eq 404 }
      it { expect(response.body).to be_blank }
    end
  end
end
