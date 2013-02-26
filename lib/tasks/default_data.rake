namespace :recipes do

  desc 'Create default measures'
  task :create_default_measures => :environment do
    Measure.transaction do
      Measure.create(:name => 'Each', :description => 'A single item')
      Measure.create(:name => 'Each - Small', :description => 'A single item - small')
      Measure.create(:name => 'Each - Medium', :description => 'A single item - medium')
      Measure.create(:name => 'Each - Large', :description => 'A single item - large')
      Measure.create(:name => 'Teaspoon', :description => 'Teaspoon')
      Measure.create(:name => 'Tablespoon', :description => 'Tablespoon')
      Measure.create(:name => 'Dessertspoon', :description => 'Dessertspoon')
      Measure.create(:name => 'Cup', :description => 'Cup')
      Measure.create(:name => 'Millilitre', :description => 'Millilitre')
      Measure.create(:name => 'Gram', :description => 'Gram')
      Measure.create(:name => 'Litre', :description => 'Litre')
      Measure.create(:name => 'Kilogram', :description => 'Kilogram')
      Measure.create(:name => 'Ounce', :description => 'Ounce')
      Measure.create(:name => 'Pound', :description => 'Pound')
      Measure.create(:name => 'Inch', :description => 'Pound')
      Measure.create(:name => 'Centimeter', :description => 'Pound')
    end

  end

  desc 'Create default cuisines'
  task :create_default_cuisines => :environment do
    Cuisine.transaction do
      Cuisine.create(:name => 'Indian')
      Cuisine.create(:name => 'Chinese')
      Cuisine.create(:name => 'French')
      Cuisine.create(:name => 'Italian')
      Cuisine.create(:name => 'Spanish')
      Cuisine.create(:name => 'American')
      Cuisine.create(:name => 'Northern European')
      Cuisine.create(:name => 'Eastern European')
      Cuisine.create(:name => 'South American')
      Cuisine.create(:name => 'Japanese')
      Cuisine.create(:name => 'Far Eastern')
      Cuisine.create(:name => 'British')
      Cuisine.create(:name => 'Middle Eastern')
      Cuisine.create(:name => 'African')
      Cuisine.create(:name => 'Caribbean')
      Cuisine.create(:name => 'Mexican')
      Cuisine.create(:name => 'Other')
    end
  end

  desc 'Create default categories'
  task :create_default_categories => :environment do
    Category.transaction do
      c = Category.create(:name => 'Cooking Methods', :display_order => 1)
      c.children.create(:name => 'Fry')
      c.children.create(:name => 'Stew')
      c.children.create(:name => 'Grill')
      c.children.create(:name => 'BBQ')
      c.children.create(:name => 'Bake')
      c.children.create(:name => 'Casserole')
      c.children.create(:name => 'Steam')
      c.children.create(:name => 'Stir Fry')
      c.children.create(:name => 'Slow Cook')
      c.children.create(:name => 'Roast')
      c.children.create(:name => 'Marinate')
      c.children.create(:name => 'Raw')
      c.children.create(:name => 'Boil')

      c = Category.create(:name => 'Food Category', :display_order => 3)
      c.children.create(:name => 'Meat')
      c.children.create(:name => 'Fish')
      c.children.create(:name => 'Fowl')
      c.children.create(:name => 'Vegan')
      c.children.create(:name => 'Vegetarian')
      c.children.create(:name => 'Dairy')

      c = Category.create(:name => 'Type of Meal', :display_order => 2)
      c.children.create(:name => 'Breakfast')
      c.children.create(:name => 'Brunch')
      c.children.create(:name => 'Lunch')
      c.children.create(:name => 'Dinner')
      c.children.create(:name => 'Snack')
      c.children.create(:name => 'Dessert')
      c.children.create(:name => 'Starter')
      c.children.create(:name => 'Sweets')
      c.children.create(:name => 'Picnic')
      c.children.create(:name => 'Afternoon Tea')
      c.children.create(:name => 'Cakes')
      c.children.create(:name => 'Hors D\'oeuvre')
      c.children.create(:name => 'Side Dish')

      c = Category.create(:name => 'Baby Food')
      c.children.create(:name => 'Sweet')
      c.children.create(:name => 'Savoury')
      c.children.create(:name => 'Drinks')

      c = Category.create(:name => 'Pet Food')
      c.children.create(:name => 'Dogs')
      c.children.create(:name => 'Cats')
      c.children.create(:name => 'Other')

      c = Category.create(:name => 'Occasions')
      c.children.create(:name => 'Christmas')
      c.children.create(:name => 'Thanks Giving')
      c.children.create(:name => 'Eid')
      c.children.create(:name => 'Easter')
      c.children.create(:name => 'Children Parties')
      c.children.create(:name => 'Dinner Parties')

      c = Category.create(:name => 'Beverages')
      c.children.create(:name => 'Alcoholic')
      c.children.create(:name => 'Non-Alcoholic')
      c.children.create(:name => 'Shake')
      c.children.create(:name => 'Tea')
      c.children.create(:name => 'Punch')
      c.children.create(:name => 'Cocktail')
      c.children.create(:name => 'Cordial')
      c.children.create(:name => 'Health')

      c = Category.create(:name => 'Special Diet')
      c.children.create(:name => 'Nut Free')
      c.children.create(:name => 'Gluten Free')
      c.children.create(:name => 'Dairy Free')

    end
  end

  desc 'Award Badges'
  task :award_badges => :environment do
    Achievement.transaction do
      Follower.all.each{|follower| FolloweeBadge.award_achievements_for(follower.following)}
      RecipeFork.all.each{|recipe_fork|  ForkBadges.award_achievements_for(recipe_fork.forker)}
      RecipeWatcher.all.each{|recipe_watcher| WatcherBadge.award_achievements_for(recipe_watcher.user)}
      Recipe.all.each{|recipe| RecipeBadges.award_achievements_for(recipe.user)}
      Blog.all.each{|blog| BloggerBadge.award_achievements_for(blog.user)}
      Rating.all.each do |rating|
        VoterBadge.award_achievements_for(rating.user)
        VotesFiveStar.award_achievements_for(rating.user)
        VotesOneStar.award_achievements_for(rating.user)
        if rating.rateable_type == 'Recipe'
          VotesGoodRecipe.award_achievements_for(rating.rateable.user)
        end
      end
    end
  end

  desc 'Update All Recipe Nutrition'
  task :update_all_recipe_nutrition => :environment do
    Recipe.transaction do
      Recipe.all(:include => [{:recipe_ingredients => :measure}]).each do |recipe|
        recipe.calculate_nutrition
        recipe.done_nutrition_at = Time.now
        recipe.save(:without_revision => true)
      end
    end
  end

  desc 'Update Recent Recipe Nutrition'
  task :update_recent_recipe_nutrition => :environment do
    Recipe.transaction do
      Recipe.not_done_nutritions.all(:include => [{:recipe_ingredients => :measure}]).each do |recipe|
        recipe.calculate_nutrition
        recipe.done_nutrition_at = Time.now
        recipe.save(:without_revision => true)
      end
    end
  end

  desc "Process Reputations"
  task :process_reputation => :environment do

    #get process_voter_reputation
    include VoterReputation

    Reputation.transaction do
      Recipe.all.each{|recipe| Reputation.process_reputation_for(recipe)}
      Blog.all.each{|blog| Reputation.process_reputation_for(blog)}
      Achievement.all.each{|achievement| Reputation.process_reputation_for(achievement)}
      Rating.all.each do|rating|
        Reputation.process_reputation_for(rating)
        process_voter_reputation(rating)
      end
    end
  end



end
