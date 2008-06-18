# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 18) do

  create_table "amenities", :force => true do |t|
    t.string   "name",         :limit => 40, :default => "", :null => false
    t.text     "description",                                :null => false
    t.integer  "lock_version", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "body_parts", :force => true do |t|
    t.string   "name",         :limit => 20, :default => "", :null => false
    t.string   "category",     :limit => 20, :default => "", :null => false
    t.integer  "lock_version", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cpt_codes", :force => true do |t|
    t.integer  "code",         :limit => 11,                :null => false
    t.text     "description",                               :null => false
    t.integer  "lock_version", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_ranges", :force => true do |t|
    t.integer  "position",     :limit => 11,                :null => false
    t.float    "low",                                       :null => false
    t.float    "high",                                      :null => false
    t.integer  "lock_version", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provider_amenities", :force => true do |t|
    t.integer  "provider_id",  :limit => 11,                :null => false
    t.integer  "amenity_id",   :limit => 11,                :null => false
    t.integer  "lock_version", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_amenities", ["provider_id"], :name => "fk_provider_amenity_providers"
  add_index "provider_amenities", ["amenity_id"], :name => "fk_provider_smenity_amenities"

  create_table "provider_services", :force => true do |t|
    t.integer  "provider_id",  :limit => 11,                                              :null => false
    t.integer  "service_id",   :limit => 11,                                              :null => false
    t.decimal  "list_price",                 :precision => 8, :scale => 2
    t.integer  "lock_version", :limit => 11,                               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.decimal  "cash_price",                 :precision => 8, :scale => 2
  end

  add_index "provider_services", ["provider_id"], :name => "fk_provider_service_providers"
  add_index "provider_services", ["service_id"], :name => "fk_provider_service_services"

  create_table "providers", :force => true do |t|
    t.string   "name",         :limit => 50,  :default => "", :null => false
    t.string   "address1",     :limit => 50,  :default => "", :null => false
    t.string   "address2",     :limit => 50
    t.string   "city",         :limit => 50,  :default => "", :null => false
    t.string   "state",        :limit => 2,   :default => "", :null => false
    t.string   "zip",          :limit => 9,   :default => "", :null => false
    t.string   "phone",        :limit => 14,  :default => "", :null => false
    t.string   "email",        :limit => 50
    t.string   "contact",      :limit => 50
    t.string   "url",          :limit => 256
    t.integer  "lock_version", :limit => 11,  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "searches", :force => true do |t|
  end

  create_table "services", :force => true do |t|
    t.string   "name",         :limit => 40, :default => "", :null => false
    t.text     "description"
    t.integer  "cpt_code_id",  :limit => 11
    t.integer  "lock_version", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["cpt_code_id"], :name => "pp2_fk_service_cpt_codes"

  create_table "sponsored_links", :force => true do |t|
    t.string "title",       :limit => 40, :default => "", :null => false
    t.text   "description",                               :null => false
    t.text   "url",                                       :null => false
    t.string "domain_name", :limit => 40, :default => "", :null => false
  end

  create_table "synonyms", :force => true do |t|
    t.integer "word_id",    :limit => 11, :null => false
    t.integer "synonym_id", :limit => 11, :null => false
  end

  add_index "synonyms", ["word_id"], :name => "fk_synonym_word"
  add_index "synonyms", ["synonym_id"], :name => "fk_synonym_child"

  create_table "words", :force => true do |t|
    t.string "text", :limit => 20, :default => "", :null => false
  end

end
