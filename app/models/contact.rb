class Contact < ApplicationRecord
    validates_presence_of :correo, :nombre, :telefono
    attr_accessor :url_token
end
