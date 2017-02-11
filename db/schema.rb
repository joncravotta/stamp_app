# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170211212602) do

  create_table "accounts", force: :cascade do |t|
    t.string   "created_by"
    t.integer  "seat_count"
    t.integer  "email_count"
    t.string   "company_name"
    t.string   "company_name_digital"
    t.string   "stripe_plan_id"
    t.integer  "stripe_current_period_start"
    t.integer  "stripe_current_period_end"
    t.integer  "stripe_canceled_at"
    t.string   "stripe_sub_type"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "is_valid",                    default: false
    t.string   "cc_last_four"
  end

# Could not dump table "slices" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "templates", force: :cascade do |t|
    t.string   "html",        default: ""
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name"
    t.boolean  "completed",   default: false
    t.string   "email_width", default: ""
  end

  create_table "uploaded_images", force: :cascade do |t|
    t.string   "user_id"
    t.string   "template_id"
    t.string   "url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                       default: "",    null: false
    t.string   "encrypted_password",          default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "paid",                        default: false
    t.string   "header",                      default: ""
    t.string   "footer",                      default: ""
    t.string   "url_path",                    default: ""
    t.string   "email_width",                 default: "600"
    t.boolean  "header_active",               default: false
    t.boolean  "footer_active",               default: false
    t.boolean  "admin",                       default: false
    t.integer  "account_id"
    t.string   "stripe_customer_id"
    t.integer  "stripe_current_period_start"
    t.integer  "stripe_current_period_end"
    t.string   "stripe_plan_id"
    t.integer  "stripe_canceled_at"
    t.integer  "email_code_count"
    t.string   "subscription_type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",           default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
