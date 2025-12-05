class AddFieldsToTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :category, :string
    add_column :tickets, :sub_category, :string
    add_column :tickets, :impact_others, :boolean
  end
end
