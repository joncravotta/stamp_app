class Slice < ActiveRecord::Migration
  def change
    create_table :slices do |t|
      t.string :user_id
      t.string :image
    end
  end
end
