class AddDefaultToImpactOthers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :tickets, :impact_others, false
  end
end
