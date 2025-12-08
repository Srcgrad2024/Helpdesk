class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :contact, :string
  end
end
