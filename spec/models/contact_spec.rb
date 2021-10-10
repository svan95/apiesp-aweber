require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { should validate_presence_of(:correo) }
  it { should validate_presence_of(:nombre) }
  it { should validate_presence_of(:telefono) }
end
