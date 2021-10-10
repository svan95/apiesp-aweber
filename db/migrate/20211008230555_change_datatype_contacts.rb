class ChangeDatatypeContacts < ActiveRecord::Migration[6.0]
  def change
    def up
      change_column :contacts, :send_information_status, :bool
    end
  
    def down
      change_column :contacts, :send_information_status, :string
    end
  end
end
