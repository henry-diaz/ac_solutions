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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130423075221) do

  create_table "adjustments", :force => true do |t|
    t.date     "adjustment_date"
    t.integer  "sku_id"
    t.integer  "user_id"
    t.integer  "quantity"
    t.string   "comment"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "adjustments", ["sku_id"], :name => "index_adjustments_on_sku_id"
  add_index "adjustments", ["user_id"], :name => "index_adjustments_on_user_id"

  create_table "appointments", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.text     "description"
    t.text     "address"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "user_id"
    t.integer  "come",        :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "appointments", ["customer_id"], :name => "index_appointments_on_customer_id"
  add_index "appointments", ["user_id"], :name => "index_appointments_on_user_id"

  create_table "appointments_users", :id => false, :force => true do |t|
    t.integer "appointment_id"
    t.integer "user_id"
  end

  add_index "appointments_users", ["appointment_id", "user_id"], :name => "index_appointments_users_on_appointment_id_and_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "skus_count",  :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "charges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.integer  "active",           :default => 1
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "charge_id"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "contacts", ["active"], :name => "index_contacts_on_active"
  add_index "contacts", ["charge_id"], :name => "index_contacts_on_charge_id"
  add_index "contacts", ["contactable_id", "contactable_type"], :name => "index_contacts_on_contactable_id_and_contactable_type"
  add_index "contacts", ["contactable_type", "contactable_id"], :name => "index_contacts_on_contactable_type_and_contactable_id"

  create_table "customers", :force => true do |t|
    t.integer  "active",      :default => 1
    t.string   "code"
    t.string   "name"
    t.string   "kind"
    t.text     "description"
    t.string   "phone"
    t.text     "address"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "customers", ["active"], :name => "index_customers_on_active"
  add_index "customers", ["kind"], :name => "index_customers_on_kind"
  add_index "customers", ["name"], :name => "index_customers_on_name"
  add_index "customers", ["phone"], :name => "index_customers_on_phone"

  create_table "emails", :force => true do |t|
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.string   "address"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "emails", ["emailable_id", "emailable_type"], :name => "index_emails_on_emailable_id_and_emailable_type"
  add_index "emails", ["emailable_type", "emailable_id"], :name => "index_emails_on_emailable_type_and_emailable_id"

  create_table "items", :force => true do |t|
    t.integer  "resourceable_id"
    t.string   "resourceable_type"
    t.integer  "sku_id"
    t.integer  "quantity"
    t.decimal  "unit_price",        :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "items", ["resourceable_id", "resourceable_type"], :name => "index_items_on_resourceable_id_and_resourceable_type"
  add_index "items", ["sku_id"], :name => "index_items_on_sku_id"

  create_table "liquidateds", :force => true do |t|
    t.date     "liquidated_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "phones", :force => true do |t|
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.string   "number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "phones", ["phoneable_id", "phoneable_type"], :name => "index_phones_on_phoneable_id_and_phoneable_type"
  add_index "phones", ["phoneable_type", "phoneable_id"], :name => "index_phones_on_phoneable_type_and_phoneable_id"

  create_table "purchases", :force => true do |t|
    t.integer  "status",        :default => 0
    t.date     "purchase_date"
    t.string   "number"
    t.string   "comment"
    t.integer  "items_count",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "purchases", ["number"], :name => "index_purchases_on_number"

  create_table "sales", :force => true do |t|
    t.integer  "status",      :default => 0
    t.date     "sale_date"
    t.integer  "customer_id"
    t.string   "comment"
    t.integer  "items_count", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "sales", ["customer_id"], :name => "index_sales_on_customer_id"

  create_table "skus", :force => true do |t|
    t.integer  "active",                                    :default => 1
    t.integer  "category_id"
    t.string   "code"
    t.string   "name"
    t.decimal  "unit_price",  :precision => 8, :scale => 2, :default => 0.0
    t.integer  "quantity"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "skus", ["active"], :name => "index_skus_on_active"
  add_index "skus", ["category_id"], :name => "index_skus_on_category_id"
  add_index "skus", ["code"], :name => "index_skus_on_code"
  add_index "skus", ["name"], :name => "index_skus_on_name"

  create_table "transactions", :force => true do |t|
    t.date     "transaction_date"
    t.integer  "sku_id"
    t.integer  "user_id"
    t.integer  "initial_inventory"
    t.integer  "ending_inventory"
    t.integer  "sales"
    t.integer  "purchases"
    t.integer  "adjustments"
    t.decimal  "amount",            :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "transactions", ["sku_id"], :name => "index_transactions_on_sku_id"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.boolean  "active",                 :default => true
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
