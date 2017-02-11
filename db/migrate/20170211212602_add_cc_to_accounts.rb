class AddCcToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :cc_last_four, :string, default: nil
  end
end
