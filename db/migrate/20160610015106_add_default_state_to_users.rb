class AddDefaultStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header_active, :boolean, default: false
    add_column :users, :footer_active, :boolean, default: false
  end
end
