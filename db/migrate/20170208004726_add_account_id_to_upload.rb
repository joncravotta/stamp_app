class AddAccountIdToUpload < ActiveRecord::Migration
  def change
    add_column :uploaded_images, :account_id, :string
  end
end
