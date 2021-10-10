class AddSentAweberToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :sent_aweber, :string
  end
end
