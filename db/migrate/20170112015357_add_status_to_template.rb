class AddStatusToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :completed, :boolean, default: false
    add_column :templates, :email_width, :string, default: ''
  end
end
