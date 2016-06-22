class ChangeDateTypeUser < ActiveRecord::Migration
  def change
    change_column :users, :stripe_current_period_start, :integer, default: nil
    change_column :users, :stripe_current_period_end, :integer, default: nil
    change_column :users, :stripe_canceled_at, :integer, default: nil
  end
end
