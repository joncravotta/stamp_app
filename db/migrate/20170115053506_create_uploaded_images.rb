class CreateUploadedImages < ActiveRecord::Migration
  def change
    create_table :uploaded_images do |t|
      t.string :user_id
      t.string :template_id
      t.string :url
      t.timestamps null: false
    end
  end
end
