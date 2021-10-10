class ContactsController < ApplicationController
    before_action :set_contact, only: [:show, :update, :destroy]

  # GET /contacts
  def index
    @contacts = Contact.all
    json_response(@contacts)
  end

  # POST /contacts
  def create
    @contact = Contact.create!(contact_params)
    json_response(@contact, :created)
  end

  # GET /contacts/:id
  def show
    json_response(@contact)
  end

  # PUT /contacts/:id
  def update
    @contact.update(contact_params)
    head :no_content
  end

  # DELETE /contacts/:id
  def destroy
    @contact.destroy
    head :no_content
  end

  def token
    get_token(params[:url_token])
  end

  private

  def contact_params
    params.permit(:correo, :nombre, :telefono, :send_information_status)
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end
end
