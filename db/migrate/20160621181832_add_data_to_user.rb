class AddDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string, default: nil
    add_column :users, :stripe_current_period_start, :integer, default: nil
    add_column :users, :stripe_current_period_end, :integer, default: nil
    add_column :users, :stripe_plan_id, :string, default: nil
    add_column :users, :stripe_canceled_at, :integer, default: nil
    add_column :users, :email_code_count, :integer, default: nil
    add_column :users, :subscription_type, :string, default: nil
  end
end
