class ChangeRoleToIntegerOnUsers < ActiveRecord::Migration[8.1]
  def change
    # change column to integer, default 0 (user), not null
    change_column :users, :role, :integer, default: 0, null: false
  end
end
