# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_10_034310) do

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "event_orders", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "event_id"
    t.integer "quantity"
    t.datetime "paid_at"
    t.integer "payment_id"
    t.integer "adult_count"
    t.integer "child_count"
    t.datetime "shipped_at"
    t.integer "shipping_company"
    t.string "tracking_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_event_orders_on_cart_id"
    t.index ["event_id"], name: "index_event_orders_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.integer "price"
    t.integer "stock"
    t.integer "adult_price"
    t.integer "child_price"
    t.string "description"
    t.string "location"
    t.date "first_date"
    t.date "last_date"
    t.time "start_time"
    t.time "end_time"
    t.time "start_time_alt"
    t.time "end_time_alt"
    t.integer "remaining_ticket_numbers"
    t.boolean "status", default: false, null: false
    t.integer "owner_id"
    t.integer "store_id", default: 1
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "store_id", default: 1
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "stock"
    t.datetime "purchasing_date"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "category"
    t.integer "category_number", default: 0
    t.integer "category_order", default: 0
    t.string "category_title"
    t.integer "category_title_number", default: 0
    t.integer "category_title_order", default: 0
    t.string "title"
    t.string "full_title"
    t.integer "charge", default: 0
    t.integer "original_charge", default: 0
    t.string "description"
    t.integer "treatment_time", default: 0
    t.integer "course_number", default: 0
    t.integer "image_flag", default: 0
    t.integer "menu_flag", default: 0
    t.integer "reserve_flag", default: 0
    t.integer "add_nail_count", default: 0
    t.integer "store_id", default: 1
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.boolean "display_flag", default: true
    t.integer "staff_id"
    t.integer "store_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["staff_id"], name: "index_notifications_on_staff_id"
    t.index ["store_id"], name: "index_notifications_on_store_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "item_id"
    t.integer "quantity"
    t.datetime "paid_at"
    t.integer "payment_id"
    t.integer "adult_count"
    t.integer "child_count"
    t.datetime "shipped_at"
    t.integer "shipping_company"
    t.string "tracking_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["item_id"], name: "index_orders_on_item_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "subtotal"
    t.integer "tax"
    t.integer "shipping_fee"
    t.integer "total"
    t.time "checked_at"
    t.time "all_shipped_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_payments_on_cart_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "store_id", default: 1
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "title_for_guest"
    t.string "title_for_staff"
    t.integer "course", default: 0
    t.integer "status", default: 0
    t.string "comment"
    t.integer "staff_id"
    t.integer "guest_id"
    t.datetime "reservation_time"
    t.integer "cancel_flag", default: 0
    t.integer "validate_flag", default: 0
    t.string "treatment_menu"
    t.integer "treatment_time_menu", default: 0
    t.integer "full_treatment_time_menu", default: 0
    t.integer "charge_menu", default: 0
    t.integer "full_charge_menu", default: 0
    t.integer "add_nail_number_menu", default: 0
    t.integer "add_nail_count_menu", default: 0
    t.integer "topping_number_menu", default: 0
    t.string "topping_menu"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_reviewed", default: false
    t.integer "review_id"
    t.boolean "is_review_answered", default: false
    t.integer "review_answer_id"
  end

  create_table "review_answers", force: :cascade do |t|
    t.integer "reservation_id", null: false
    t.integer "review_id"
    t.integer "staff_id"
    t.integer "user_id"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reservation_id"], name: "index_review_answers_on_reservation_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "reservation_id", null: false
    t.string "title"
    t.text "content"
    t.integer "total_score"
    t.integer "menu_score"
    t.integer "customer_score"
    t.integer "atmosphere_score"
    t.boolean "review_exists", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nickname"
    t.boolean "is_review_answered", default: false
    t.integer "review_answer_id"
    t.index ["reservation_id"], name: "index_reviews_on_reservation_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.integer "working_staff", default: 1
    t.date "working_day"
    t.integer "store_id", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "staffs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "store_id", default: 1
    t.integer "authority"
    t.string "name"
    t.string "kana"
    t.string "phone"
    t.integer "sex"
    t.datetime "birthday"
    t.string "address"
    t.datetime "enter_date"
    t.datetime "exit_date"
    t.boolean "flag", default: false
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_staffs_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "line_id"
    t.string "address"
    t.string "description"
    t.time "opening_time"
    t.time "closing_time"
    t.time "last_order_time"
    t.string "non_business_day"
    t.integer "working_staff"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_map"
    t.boolean "flagship_location", default: false
  end

  create_table "tops", force: :cascade do |t|
    t.string "reserve_title"
    t.string "reserve_text"
    t.string "reserve_text_caution"
    t.string "reserve_text2"
    t.string "reserve_text2_caution"
    t.string "reserve_comfirm_title"
    t.string "reserve_comfirm_text"
    t.string "calendar_title"
    t.string "introduction_title"
    t.string "introduction_text"
    t.string "introduction_address"
    t.string "introduction_time"
    t.string "introduction_holiday"
    t.string "introduction_tel"
    t.string "image_text"
    t.integer "image_order"
    t.integer "slide_number"
    t.integer "slide_image_count"
    t.integer "introduction_image_count"
    t.integer "main_slide_flag", default: 0
    t.integer "introduction_image_flag", default: 0
    t.integer "reserve_image_flag", default: 0
    t.integer "store_id", default: 1
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "", null: false
    t.string "kana"
    t.string "phone"
    t.integer "sex"
    t.datetime "birthday"
    t.datetime "enter_date"
    t.datetime "exit_date"
    t.boolean "flag", default: false, null: false
    t.integer "cart_id"
    t.integer "store_id", default: 1
    t.string "provider"
    t.string "uid"
    t.integer "postal_code"
    t.string "prefecture_code"
    t.string "city"
    t.string "street"
    t.string "other_address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
  end

  add_foreign_key "carts", "users"
  add_foreign_key "event_orders", "carts"
  add_foreign_key "event_orders", "events"
  add_foreign_key "notifications", "staffs"
  add_foreign_key "notifications", "stores"
  add_foreign_key "orders", "carts"
  add_foreign_key "orders", "items"
  add_foreign_key "payments", "carts"
  add_foreign_key "review_answers", "reservations"
  add_foreign_key "reviews", "reservations"
  add_foreign_key "reviews", "users"
  add_foreign_key "staffs", "stores"
  add_foreign_key "users", "stores"
end
