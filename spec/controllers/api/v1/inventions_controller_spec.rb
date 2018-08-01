require 'rails_helper'

RSpec.describe Api::V1::InventionsController, type: :controller do
  # TODO the `fabricator` gem is a good alternative to very explicit object creation
  let(:bit1) { Bit.create!(name: Faker::Name.name) }
  let(:bit2) { Bit.create!(name: Faker::Name.name) }
  let(:invention) do
    Invention.create!(title: Faker::Name.name, description: Faker::Lorem.sentence, bits: [bit1, bit2])
  end

  let(:parsed_response_body) { JSON.parse(response.body) }

  # TODO return 404 for this, and routes not implemented for /api/v1/bits
  describe '#index' do
    it 'is not implemented' do
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

  describe '#create' do
    let(:required_params) do
      {
        bit_ids: [bit1.id, bit2.id],
        description: Faker::Lorem.sentence(rand(1..10)),
        title: Faker::Hipster.words(rand(3..10), true, true).join
      }
    end

    let(:optional_params) do
      {
        email: Faker::Internet.email,
        materials: ['scissors', 'duct tape', 'tears'],
        username: Faker::Internet.username
      }
    end

    context 'with required attributes' do
      let(:call) { post :create, params: required_params }

      it { expect { call }.to change { Invention.count }.by(1) }

      describe 'successful response' do
        before { call }

        it { expect(response.status).to eq 201 }

        it { expect(response.body).to eq Invention.last.to_json }

        it { expect(Invention.last.bit_ids).to eq required_params[:bit_ids] }
        it { expect(Invention.last.description).to eq required_params[:description] }
        it { expect(Invention.last.email).to be_nil }
        it { expect(Invention.last.title).to eq required_params[:title] }
        it { expect(Invention.last.username).to be_nil }
      end
    end

    context 'without all the required attributes' do
      let(:call) { post :create, params: optional_params }

      it { expect { call }.to_not change { Invention.count } }

      describe 'error response' do
        before { call }

        it { expect(response.status).to eq 422 }
        it { expect(parsed_response_body.keys).to eq ['error'] }

        it do
          message = "Validation failed: Bits can't be blank, Description can't be blank, Title can't be blank"
          expect(parsed_response_body['error']).to eq message
        end
      end
    end

    context 'with all required and optional attributes' do
      let(:call) { post :create, params: required_params.merge(optional_params) }

      it { expect { call }.to change { Invention.count }.by(1) }

      describe 'successful response' do
        before { call }

        it { expect(response.status).to eq 201 }

        it { expect(response.body).to eq Invention.last.to_json }

        it { expect(Invention.last.bit_ids).to eq required_params[:bit_ids] }
        it { expect(Invention.last.description).to eq required_params[:description] }
        it { expect(Invention.last.email).to eq optional_params[:email] }
        it { expect(Invention.last.title).to eq required_params[:title] }
        it { expect(Invention.last.username).to eq optional_params[:username] }
      end
    end

    # NOTE could continue testing here with combinations of params, or sending extra unpermitted params...

    context '(XSS) stripping HTML inputs' do
      let(:malicious_string) { "<script>alert('Hello');</script>" }

      it 'strips from title' do
        post :create, params: required_params.merge(title: "My awesome #{malicious_string} invention")
        expect(parsed_response_body['title']).to eq "My awesome alert('Hello'); invention"
      end

      # TODO add for all user-defined fields
    end
  end

  describe '#destroy' do
    before { invention }

    it 'allows delete by id' do
      expect { delete :destroy, params: { id: invention.id} }.to change { Invention.count }.by(-1)
      expect { invention.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
