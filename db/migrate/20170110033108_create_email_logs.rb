class CreateEmailLogs < ActiveRecord::Migration
  def change
    create_table :email_logs do |t|
      
      t.integer :user_id
      t.string :user_email
      t.string :email_type
      t.timestamps null: false

    end
  end
end
