class AddDefaultsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header, :string, default: ''
    add_column :users, :footer, :string, default: ''
    add_column :users, :url_path, :string, default: ''
    add_column :users, :email_width, :string, default: '600'
  end
end
