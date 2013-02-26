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

ActiveRecord::Schema.define(:version => 20110424082443) do

  create_table "achievements", :force => true do |t|
    t.string   "type"
    t.string   "level_name"
    t.string   "description"
    t.integer  "level"
    t.integer  "user_id"
    t.boolean  "notified",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "achievements", ["user_id"], :name => "index_achievements_on_user_id"

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action",     :limit => 50
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.string   "extra",      :limit => 200
  end

  add_index "activities", ["item_id"], :name => "index_activities_on_item_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "blogs", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "views_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "id_path"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "level"
    t.integer  "children_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "family_id"
    t.integer  "display_order"
  end

  add_index "categories", ["family_id"], :name => "index_categories_on_family_id"
  add_index "categories", ["id_path"], :name => "index_categories_on_id_path"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "categories_members", :force => true do |t|
    t.integer  "category_id"
    t.integer  "member_id"
    t.string   "member_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories_members", ["category_id"], :name => "index_categories_members_on_category_id"
  add_index "categories_members", ["member_id"], :name => "index_categories_members_on_member_id"

  create_table "cooking_methods", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cuisines", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", :force => true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followers", ["from_user_id"], :name => "index_followers_on_from_user_id"
  add_index "followers", ["to_user_id"], :name => "index_followers_on_to_user_id"

  create_table "images", :force => true do |t|
    t.string   "imageable_type",       :limit => 30
    t.integer  "imageable_id"
    t.integer  "user_id"
    t.string   "picture_file_name",    :limit => 254
    t.string   "picture_content_type", :limit => 30
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "views_count",                         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["imageable_id"], :name => "index_images_on_imageable_id"
  add_index "images", ["user_id"], :name => "index_images_on_user_id"

  create_table "ingredient_relations", :force => true do |t|
    t.integer  "ingredient_id"
    t.integer  "relation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredient_relations", ["ingredient_id"], :name => "index_ingredient_relations_on_ingredient_id"
  add_index "ingredient_relations", ["relation_id"], :name => "index_ingredient_relations_on_relation_id"

  create_table "ingredients", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "recipes_count",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number",           :default => 0
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current",       :default => true
    t.integer  "posts_count",                :default => 0
    t.integer  "topics_count",               :default => 0
    t.integer  "views_count",                :default => 0
    t.integer  "images_count",               :default => 0
    t.integer  "ingredient_group",           :default => 100
    t.integer  "food_id"
    t.integer  "user_id"
    t.integer  "updated_by_id"
  end

  add_index "ingredients", ["food_id"], :name => "index_ingredients_on_food_id"
  add_index "ingredients", ["name"], :name => "index_ingredients_on_name"
  add_index "ingredients", ["updated_by_id"], :name => "index_ingredients_on_updated_by_id"
  add_index "ingredients", ["user_id"], :name => "index_ingredients_on_user_id"

  create_table "measures", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ratio"
  end

  create_table "nutritions", :force => true do |t|
    t.integer  "ingredient_id"
    t.integer  "serving_id"
    t.integer  "added_by_id"
    t.float    "fiber"
    t.float    "protein"
    t.float    "fat"
    t.float    "sugar"
    t.float    "sodium"
    t.float    "calories"
    t.float    "carbohydrate"
    t.float    "saturated_fat"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cholesterol"
    t.string   "serving_url"
    t.text     "nutrition_table"
    t.float    "each_grams"
    t.float    "potassium"
  end

  add_index "nutritions", ["added_by_id"], :name => "index_nutritions_on_added_by_id"
  add_index "nutritions", ["ingredient_id"], :name => "index_nutritions_on_ingredient_id"
  add_index "nutritions", ["serving_id"], :name => "index_nutritions_on_serving_id"

  create_table "ratings", :force => true do |t|
    t.integer  "rating",                      :default => 0
    t.datetime "created_at",                                  :null => false
    t.string   "rateable_type", :limit => 15, :default => "", :null => false
    t.integer  "rateable_id",                 :default => 0,  :null => false
    t.integer  "user_id",                     :default => 0,  :null => false
    t.string   "ip",            :limit => 15, :default => "", :null => false
  end

  add_index "ratings", ["ip"], :name => "ip"
  add_index "ratings", ["rateable_id"], :name => "index_ratings_on_rateable_id"
  add_index "ratings", ["user_id"], :name => "user_id"

  create_table "recipe_by_others", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipe_by_others", ["recipe_id"], :name => "index_recipe_by_others_on_recipe_id"
  add_index "recipe_by_others", ["user_id"], :name => "index_recipe_by_others_on_user_id"

  create_table "recipe_forks", :force => true do |t|
    t.integer  "from_recipe_id"
    t.integer  "to_recipe_id"
    t.integer  "forked_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "at_rev"
  end

  add_index "recipe_forks", ["forked_by_id"], :name => "index_recipe_forks_on_forked_by_id"
  add_index "recipe_forks", ["from_recipe_id"], :name => "index_recipe_forks_on_from_recipe_id"
  add_index "recipe_forks", ["to_recipe_id"], :name => "index_recipe_forks_on_to_recipe_id"

  create_table "recipe_ingredients", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "recipe_item_id"
    t.integer  "measure_id"
    t.string   "recipe_item_type"
    t.float    "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number",           :default => 0
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current",       :default => true
  end

  add_index "recipe_ingredients", ["measure_id"], :name => "index_recipe_ingredients_on_measure_id"
  add_index "recipe_ingredients", ["recipe_id"], :name => "index_recipe_ingredients_on_recipe_id"
  add_index "recipe_ingredients", ["recipe_item_id"], :name => "index_recipe_ingredients_on_recipe_item_id"
  add_index "recipe_ingredients", ["revisable_branched_from_id"], :name => "index_recipe_ingredients_on_revisable_branched_from_id"
  add_index "recipe_ingredients", ["revisable_original_id"], :name => "index_recipe_ingredients_on_revisable_original_id"

  create_table "recipe_watchers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipe_id"
    t.integer  "recipe_revision"
    t.integer  "user_id"
  end

  add_index "recipe_watchers", ["recipe_id"], :name => "index_recipe_watchers_on_recipe_id"
  add_index "recipe_watchers", ["user_id"], :name => "index_recipe_watchers_on_user_id"

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "created_by_id"
    t.integer  "difficulty"
    t.integer  "serves_from"
    t.integer  "serves_to"
    t.integer  "views_count",                               :default => 0
    t.integer  "topics_count",                              :default => 0
    t.integer  "posts_count",                               :default => 0
    t.integer  "favourites_count",                          :default => 0
    t.integer  "forks_count",                               :default => 0
    t.integer  "ingredients_count",                         :default => 0
    t.integer  "ratings_count",                             :default => 0
    t.integer  "total_time",                                :default => 0
    t.float    "ratings_total",                             :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number",                          :default => 0
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current",                      :default => true
    t.integer  "cuisine_id"
    t.integer  "cooking_method_id"
    t.integer  "recipes_count",                             :default => 0
    t.integer  "watchers_count",                            :default => 0
    t.integer  "steps_count",                               :default => 0
    t.string   "cached_tag_list",            :limit => 254
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "forked_from_id"
    t.boolean  "is_draft",                                  :default => false
    t.datetime "facebook_published_at"
    t.float    "total_fiber"
    t.float    "total_protein"
    t.float    "total_fat"
    t.float    "total_sugar"
    t.float    "total_sodium"
    t.float    "total_calories"
    t.float    "total_carbohydrate"
    t.float    "total_saturated_fat"
    t.float    "total_cholesterol"
    t.float    "total_potassium"
    t.datetime "done_nutrition_at"
    t.datetime "facebook_app_published_at"
  end

  add_index "recipes", ["cooking_method_id"], :name => "index_recipes_on_cooking_method_id"
  add_index "recipes", ["created_by_id"], :name => "index_recipes_on_created_by_id"
  add_index "recipes", ["cuisine_id"], :name => "index_recipes_on_cuisine_id"
  add_index "recipes", ["forked_from_id"], :name => "index_recipes_on_forked_from_id"
  add_index "recipes", ["revisable_branched_from_id"], :name => "index_recipes_on_revisable_branched_from_id"
  add_index "recipes", ["revisable_original_id"], :name => "index_recipes_on_revisable_original_id"

  create_table "reputations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reputable_id"
    t.integer  "reputation",                    :default => 0
    t.integer  "total",                         :default => 0
    t.string   "reason",         :limit => 200
    t.string   "reputable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reputations", ["reputable_id"], :name => "index_reputations_on_reputable_id"
  add_index "reputations", ["user_id"], :name => "index_reputations_on_user_id"

  create_table "steps", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "step_no"
    t.string   "time_required"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "revisable_original_id"
    t.integer  "revisable_branched_from_id"
    t.integer  "revisable_number",           :default => 0
    t.string   "revisable_name"
    t.string   "revisable_type"
    t.datetime "revisable_current_at"
    t.datetime "revisable_revised_at"
    t.datetime "revisable_deleted_at"
    t.boolean  "revisable_is_current",       :default => true
    t.text     "description"
    t.integer  "time_required_seconds"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "cloned_from_id"
    t.integer  "stage"
  end

  add_index "steps", ["cloned_from_id"], :name => "index_steps_on_cloned_from_id"
  add_index "steps", ["recipe_id"], :name => "index_methods_on_recipe_id"
  add_index "steps", ["revisable_branched_from_id"], :name => "index_steps_on_revisable_branched_from_id"
  add_index "steps", ["revisable_original_id"], :name => "index_steps_on_revisable_original_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_counters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recipes_count",      :default => 0
    t.integer  "blogs_count",        :default => 0
    t.integer  "topics_count",       :default => 0
    t.integer  "posts_count",        :default => 0
    t.integer  "friends_count",      :default => 0
    t.integer  "favourites_count",   :default => 0
    t.integer  "profile_view_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "following_count",    :default => 0
    t.integer  "followers_count",    :default => 0
  end

  add_index "user_counters", ["user_id"], :name => "index_user_counters_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name",             :limit => 50
    t.string   "email"
    t.datetime "last_seen_at"
    t.string   "token",            :limit => 20
    t.boolean  "admin",                          :default => false
    t.boolean  "activated",                      :default => false
    t.boolean  "active",                         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_id",      :limit => 8
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bio"
    t.integer  "activities_count",               :default => 0
    t.integer  "reputation_total",               :default => 0
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["login"], :name => "login"
  add_index "users", ["token"], :name => "users_token_index"

end
