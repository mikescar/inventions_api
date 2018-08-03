require 'rails_helper'

RSpec.describe Api::V1::InventionsController, type: :controller do
  let(:parsed_response_body) { JSON.parse(response.body) }

  # TODO the `fabricator` gem is a good alternative to very explicit object creation
  let(:bit1) { Bit.create!(name: Faker::Name.name) }
  let(:bit2) { Bit.create!(name: Faker::Name.name) }
  let(:invention) do
    Invention.create!(title: Faker::Name.name, description: Faker::Lorem.sentence, bits: [bit1, bit2])
  end

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

      # TODO add for all user-defined fields, check multiple types of malicious_string
    end
  end

  describe '#update' do
    let(:new_title) { Faker::Lorem.words(6).join }
    let(:new_email) { Faker::Internet.email }
    let!(:original_title)   { invention.title }
    let!(:original_created) { invention.created_at }
    let!(:original_updated) { invention.updated_at }

    describe 'via PATCH' do
      describe 'with required params' do
        let(:call) { patch :update, params: required_params.merge(id: invention.id, title: new_title) }

        it { expect { call }.to_not change { Invention.count } }

        describe 'results' do
          before do
            call
            invention.reload
          end

          it { expect(response.status).to eq 200 }
          it { expect(response.body).to eq invention.to_json }
          it { expect(invention.title).to eq new_title }
          it { expect(invention.created_at).to eq original_created }
          it { expect(invention.updated_at).to be > original_updated }
        end
      end

      describe 'with optional params' do
        let(:call) { patch :update, params: optional_params.merge(id: invention.id, email: new_email) }

        it { expect { call }.to_not change { Invention.count } }

        describe 'results' do
          before do
            call
            invention.reload
          end

          it { expect(response.status).to eq 200 }
          it { expect(response.body).to eq invention.to_json }
          it { expect(invention.title).to eq original_title }
          it { expect(invention.email).to eq new_email }
          it { expect(invention.created_at).to eq original_created }
          it { expect(invention.updated_at).to be > original_updated }
        end
      end

      describe 'returns validation errors with bad data' do
        it 'for email' do
          patch :update, params: { id: invention.id, email: 'asdfasdf' }
          expect(response.status).to eq 422
          expect(parsed_response_body['error']).to eq 'blank'
        end
      end
    end

    describe 'via PUT' do
      it 'will fail without ID' do
        expect { put :update, params: required_params.merge(title: new_title) }
          .to raise_error ActionController::UrlGenerationError

        invention.reload
        expect(invention.title).to eq original_title
      end

      context 'with new ID, we do not support' do
        let(:new_id) { invention.id + 1000 }

        describe 'failure with required and optional params' do
          let(:call) { put :update, params: required_params.merge(id: new_id, email: new_email) }

          it { expect { call }.to_not change { Invention.count } }
          it { call ; expect(Invention.find_by(email: new_email)).to be_nil }
        end
      end

      context 'with an existing ID' do
        describe 'success with required params' do
          let(:call) { put :update, params: required_params.merge(id: invention.id, title: new_title) }

          it { expect { call }.to_not change { Invention.count } }

          describe 'results' do
            before do
              call
              invention.reload
            end

            it { expect(response.status).to eq 200 }
            it { expect(response.body).to eq invention.to_json }
            it { expect(invention.title).to eq new_title }
            it { expect(invention.created_at).to eq original_created }
            it { expect(invention.updated_at).to be > original_updated }
          end
        end
      end
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
