class ChangeDataTypeUser < ActiveRecord::Migration
  def change
    change_column :users, :stripe_customer_id, :string, default: nil
    change_column :users, :stripe_plan_id, :string, default: nil
  end
end
