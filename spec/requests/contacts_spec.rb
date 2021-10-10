require 'rails_helper'

RSpec.describe 'Contacts API', type: :request do
  let!(:contacts) { create_list(:contact, 10) }
  let(:contact_id) { contacts.first.id }

  describe 'GET /contacts' do
    before { get '/contacts' }

    it 'returns contacts' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /contacts/:id' do
    before { get "/contacts/#{contact_id}" }

    context 'when the record exists' do
      it 'returns the contact' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(contact_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:contact_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Contact/)
      end
    end
  end

  describe 'POST /contacts' do
    let(:valid_attributes) { { correo: 'email@gmail.com', nombre: 'Pablo Valencia', telefono: '3216549870' } }

    context 'when the request is valid' do
      before { post '/contacts', params: valid_attributes }

      it 'creates a contact' do
        expect(json['correo']).to eq('email@gmail.com')
        expect(json['nombre']).to eq('Pablo Valencia')
        expect(json['telefono']).to eq('3216549870')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/contacts', params: { correo: 'email2@gmail.com', nombre: 'Pedro Perez' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Telefono can't be blank/)
      end
    end
  end

  describe 'PUT /contacts/:id' do
    let(:valid_attributes) { { correo: 'email3@gmail.com', nombre: 'Alberto Gomez', telefono: '3226322012' } }

    context 'when the record exists' do
      before { put "/contacts/#{contact_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /contacts/:id' do
    before { delete "/contacts/#{contact_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end