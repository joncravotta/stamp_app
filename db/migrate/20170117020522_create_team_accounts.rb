class CreateTeamAccounts < ActiveRecord::Migration
  def change
    create_table :team_accounts do |t|
      t.string :created_by
      t.integer :seat_count, default: nil
      t.integer :email_count, default: nil
      t.string :company_name, default: nil
      t.string :company_name_digital, default: nil
      t.string :stripe_plan_id, default: nil
      t.string :stripe_current_period_start, default: nil
      t.string :stripe_current_period_end, default: nil
      t.string :stripe_canceled_at, default: nil
      t.string :stripe_sub_type, default: nil
      t.timestamps null: false
    end
  end
end
