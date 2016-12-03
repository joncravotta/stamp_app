class AddSlicesToSlices < ActiveRecord::Migration
  def change
    add_column :slices, :slices, :json
  end
end
