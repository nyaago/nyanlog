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

ActiveRecord::Schema.define(:version => 20120101145015) do

  create_table "app_settings", :force => true do |t|
    t.integer  "default_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "folder_id"
    t.string   "title"
    t.text     "content"
    t.integer  "order_of_display"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.string   "ordering_type",         :default => "ByCreatedAtDesc", :null => false
    t.integer  "article_count_by_page", :default => 10
    t.integer  "owner_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "side_widget_set_id"
    t.string   "theme_name"
  end

  create_table "images", :force => true do |t|
    t.integer  "folder_id"
    t.string   "title",              :limit => 50
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "order_of_display"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_items", :force => true do |t|
    t.integer  "menu_id"
    t.integer  "folder_id"
    t.string   "title"
    t.integer  "order_of_display"
    t.integer  "parent_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.string   "menu_type"
    t.integer  "site_id"
    t.boolean  "hidden"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monthly_widgets", :force => true do |t|
    t.integer  "folder_id"
    t.string   "title"
    t.integer  "element_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "new_arrival_widgets", :force => true do |t|
    t.integer  "folder_id"
    t.string   "title"
    t.integer  "element_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_designs", :force => true do |t|
    t.integer  "site_id"
    t.integer  "folder_id"
    t.text     "stylesheet"
    t.string   "header_image_file_name"
    t.string   "header_image_content_type"
    t.integer  "header_image_file_size"
    t.string   "header_color",                   :limit => 10
    t.string   "background_color",               :limit => 10
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.string   "background_position"
    t.string   "background_repeat"
    t.string   "background_attachment"
    t.boolean  "background_interited_from_site",               :default => true
    t.text     "footer_html"
    t.text     "header_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "title"
    t.text     "description"
    t.date     "opend_at"
    t.date     "closed_at"
    t.boolean  "not_in_public"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_folder_id"
    t.integer  "side_widget_set_id"
    t.string   "theme_name"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "site_id"
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "single_access_token",                :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "auto_login"
    t.boolean  "is_admin"
    t.boolean  "is_site_admin"
    t.boolean  "is_editor"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_folder_id"
  end

  create_table "widget_set_elements", :force => true do |t|
    t.integer  "widget_set_id"
    t.integer  "widget_id"
    t.string   "widget_type"
    t.integer  "order_of_display"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widget_sets", :force => true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.integer  "owner_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
