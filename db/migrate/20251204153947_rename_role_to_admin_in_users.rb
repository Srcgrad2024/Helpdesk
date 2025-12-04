class RenameRoleToAdminInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :role, :admin
    change_column :users, :admin, :boolean, default: false, null: false
  end
end
