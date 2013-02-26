# About RecipeTrees

Like GitHub for recipes minus the git.

Recipe Trees is a recipe sharing website with an emphasis on the ability to categorise, search and describe recipes in easy to follow steps.

## Social Recipes

At its heart, Recipe Trees is closely tied with Facebook. This means that you will need a Facebook account to login and use Recipe Trees. This helps us eliminate spammers and trolls, who thrive on anonymity. This also means that you don't need to remember another username and password to login.

We also use Facebook's sharing and commenting facilities, which makes it easier for you to share your comments and recipes with your Facebook friends.

## Recipe Forks

The word Fork is used in Software Development to describe the process of taking a product's code and copying it for the purpose of further customisation. Joomla, for example, was forked from Mambo.

So how does this apply to recipes?

Well, Recipe Trees allows you to Fork any recipe and make it your own. Your version of the recipe becomes the Fork. You are then able to change your recipe fork any which you want and independently of the original recipe.

So if you Forked one of my recipes and then others forked your version and so on we end up with a tree which Recipe Trees is able to track and anyone would be able to navigate through to its origin.

I think this is much more interesting than just adding a recipe to a favourites list.

## Ingredients Database

Another goal of this site is to build an ingredients database based on our recipes. Initially we are not going to have many ingredients but these will be automatically added as new recipes are added.

In essence, an ingredient knows which recipes it is attached to. Once added, anyone can edit an ingredient's description and view which recipes a particular ingredient is used in.

This also allows us to use advanced filters on our recipes based on any combination of ingredients. Want to cook something with peppers, eggs and bacon? Key in your ingredients in the recipes filter page and only recipes containing your specified ingredients will be returned.

## Advanced Filtering

We've talked about ingredient filtering. You are also able to further filter recipes by tags, categories (i.e BBQ recipes) and cuisines.

# Technical Features

**Recipe Forks**: User can fork/clone a recipe and modify it to their requirements. RecipeTrees employs an acyclic graph to define all fork relationships. An example can be seen [here](http://recipetrees.com/recipes/2_plain-basmati-rice---rice-cooker) click on the Forks tab.

**Nutrition Calculator**: All ingredients are databased with an easy Admin facility where nutritional value per ingredient can be defined using [FatSecret API](http://www.fatsecret.com/). Each recipe collates all ingredients to produce a per-potion and a per-meal nutritional figures.

**Recipes all the way Down**: A recipe can list another recipe as an ingredient. In such instances a per-recipe ingredient list, instructions and nutritional breakdown are provided for each recipe plus a combined total. Example [here](http://recipetrees.com/recipes/8_slow-cooked-beef-goulash).

**Facebook Integration**: Uses Facebook Connect for seamless user-registrations. Also employs Facebook's comments widget.

**Ingredients Database**: Lists all used ingredients but also links similar ingredients, recipes that use this and similar ingredients. See [tomato](http://recipetrees.com/ingredients/178_tomato).

# Contributing

Please feel free to hack away on RecipeTrees; I hope that the interwebs forks this into something interesting :)

I would be truly grateful (and humbled) if you decide to send a pull request. Before you do, please open a ticket describing the issue that is being addresses.

# Support

This codebase has not been updated since late 2011.

RecipeTrees is released under the MIT license. Please fork and customise to your requirements.

Contact me via GitHub if you require assistance in deploying a RecipeTrees fork to your server or if you require any specific modifications.
