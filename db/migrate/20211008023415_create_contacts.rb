class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :correo
      t.string :nombre
      t.string :telefono
      t.string :send_information_status

      t.timestamps
    end
  end
end
