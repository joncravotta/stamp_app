class AddValidToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :is_valid, :boolean, default: false
  end
end
