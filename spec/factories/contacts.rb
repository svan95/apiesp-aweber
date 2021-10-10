FactoryBot.define do
    factory :contact do
      correo { Faker::Lorem.word }
      nombre { Faker::Lorem.word }
      telefono { Faker::Lorem.word }
    end
  end