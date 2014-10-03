require_relative '../models/ingredient'
require 'yummly'
require 'launchy'
require 'date'
require 'colorize'

module Model
  def self.all_ingredients
    Ingredient.all
  end

  def self.format_search_terms(ingredients, diet)
    ingredients = ingredients.join(", ")

    case diet[0].downcase
    when 'vegetarian'
      diet_string = '387^Lacto-ovo vegetarian'
    when 'vegan'
      diet_string = '386^Vegan'
    when 'pescetarian'
      diet_string = '390^Pescetarian'
    else
      diet_string = ''
    end

    [ingredients, {'allowedDiet' => diet_string}]
  end

  def self.query(array)
    results = Yummly.search(array[0], array[1])
    parsed = results.matches[0..4]
  end

  def self.get_recipe_names(parsed_recipes)
    @@recipes = {}
    parsed_recipes.each_with_index do |recipe, index|
      @@recipes.merge!(index => [recipe["id"], recipe["recipeName"], recipe["rating"]] )
    end
    @@recipes
  end

  def self.fetch_html(number)
    recipe_id = @@recipes[number][0]
    url = "http://www.yummly.com/recipe/#{recipe_id}"
    Launchy.open(url)
  end

  def self.add_ingredient(ingredient_array)
    ingredient_array.each do |ingredient|
        Ingredient.create(name: ingredient, expiration_date: (Date.today + 7))
    end
  end

  def self.delete_ingredient(name_array)
    name_array.each do |name|
        Ingredient.find_by_name(name).destroy
    end
  end

  def self.add_to_cookbook(choice)
    Recipe.create(url_id: @@recipes[choice][0], name: @@recipes[choice][1])
  end
end

module Controller
  def self.intro
    View.logo
    View.spacer_top
    View.display_pantry(Model.all_ingredients)
    View.spacer_bottom
  end

  def self.run
    command = View.options.downcase
    case command
    when 'cook'
      answer = View.get_input(command)
      View.spacer_top
      diet = View.get_diet
      View.spacer_bottom
      View.hacking_the_mainframe
      parsed = Model.query(Model.format_search_terms(answer, diet))
      View.spacer_top
      View.display_result_recipes(Model.get_recipe_names(parsed))
      View.spacer_bottom
      choice = View.pick_recipe
      Model.add_to_cookbook(choice)
      View.save_to_cookbook
      Model.fetch_html(choice)
      View.spacer_bottom
      run
    when 'add'
      answer = View.get_input(command)
      View.spacer_top
      Model.add_ingredient(answer)
      View.add_confirmation(answer)
      View.display_pantry(Model.all_ingredients)
      run
    when 'delete'
      answer = View.get_input(command)
      View.spacer_top
      Model.delete_ingredient(answer)
      View.delete_confirmation
      View.display_pantry(Model.all_ingredients)
      run
    when 'view cookbook'
      View.spacer_top
      View.view_cookbook
      run
    when 'exit'
      exit
    end
  end
end

module View
  def self.display_pantry(results)
    puts 'You currently have the following ingredients in your pantry:'.center(159)
    results.each do |object|
      puts "#{object.name.capitalize} - (exp. #{object.expiration_date})".center(159)
    end
    puts
  end

  def self.options
    puts 'Please choose from one of the following options:'.center(159)
    puts '* To add an ingredient, type \'add\' *'.center(159)
    puts '* To delete an ingredient, type \'delete\' *'.center(159)
    puts '* To see possible recipes, type \'cook\' *'.center(159)
    puts '* To see your cookbook, type \'view cookbook\' *'.center(159)
    puts '* To exit, type \'exit\' *'.center(159)
    puts
    print" "*70
    answer = gets.chomp
    puts
    answer
  end

  def self.view_cookbook
    puts 'You currently have the following recipes in your cookbook:'.center(159)
    Recipe.all.each do |object|
      puts "#{object.name.capitalize}".center(159)
    end
    puts
  end

  def self.display_result_recipes(recipe_hash)
    puts
    puts
    puts "Here is what you can cook!".center(159)
    puts
    recipe_hash.each do |key, value|
      puts "#{key + 1}. #{value[1]} - Rating: #{value[2]}/5 stars".center(159)
    end
    puts
  end

  def self.hacking_the_mainframe
    puts
    puts
    puts
    puts "HACKING THE MAINFRAME c/o Yummly.com".colorize(:green).center(159)
    puts
    159.times  { print '.'.colorize(:green); sleep 0.01}
    puts
    puts
  end

  def self.spacer_top
    puts
    spacer = '-'*50
    print spacer.colorize(:light_blue).center(173)
  end

  def self.spacer_bottom
    spacer = '-'*50
    print spacer.colorize(:light_blue).center(173)
    puts
  end

  def self.pick_recipe
    puts "Which recipe would you like to cook? Enter its number.".center(159)
    puts
    print" "*70
    answer = gets.chomp.to_i - 1
    puts
    answer
  end

  def self.add_confirmation(ingredients)
    puts "You just added #{ingredients.join(", ")} to your pantry! Time to get cookin'!".center(159)
  end

  def self.delete_confirmation
    puts "You just removed some food from your pantry. Time to go shoppin'!".center(159)
  end

  def self.get_input(command)
    puts "What would you like to #{command}?".center(159)
    puts
    print" "*70
    answer = gets.chomp.split(", ")
    puts
    answer
  end

  def self.get_diet
    puts "Which word best describes your diet?".center(159)
    puts
    puts 'Vegetarian     Vegan     Pescetarian     Anything!'.center(159)
    puts
    print" "*70
    answer = gets.chomp.split(", ")
    puts
    answer
  end

  def self.save_to_cookbook
    puts "Saved to cookbook!".center(159)
    sleep(0.5)
    puts "Loading your recipe!".center(159)
    sleep(0.5)
  end

  def self.logo
    logo =  <<-LOGO
   .----------------. .----------------. .----------------. .----------------. .----------------. .----------------. .----------------. .----------------.
  | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. |
  | |  _________   | | |  _______     | | |     _____    | | |  ________    | | |    ______    | | |  _________   | | |   _____      | | |  ____  ____  | |
  | | |_   ___  |  | | | |_   __ \\    | | |    |_   _|   | | | |_   ___ `.  | | |  .' ___  |   | | | |_   ___  |  | | |  |_   _|     | | | |_  _||_  _| | |
  | |   | |_  \\_|  | | |   | |__) |   | | |      | |     | | |   | |   `. \\ | | | / .'   \\_|   | | |   | |_  \\_|  | | |    | |       | | |   \\ \\  / /   | |
  | |   |  _|      | | |   |  __ /    | | |      | |     | | |   | |    | | | | | | |    ____  | | |   |  _|  _   | | |    | |   _   | | |    \\ \\/ /    | |
  | |  _| |_       | | |  _| |  \\ \\_  | | |     _| |_    | | |  _| |___.' / | | | \\ `.___]  _| | | |  _| |___/ |  | | |   _| |__/ |  | | |    _|  |_    | |
  | | |_____|      | | | |____| |___| | | |    |_____|   | | | |________.'  | | |  `._____.'   | | | |_________|  | | |  |________|  | | |   |______|   | |
  | |              | | |              | | |              | | |              | | |              | | |              | | |              | | |              | |
  | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' |
   '----------------' '----------------' '----------------' '----------------' '----------------' '----------------' '----------------' '----------------'
 LOGO
 puts logo.colorize(:blue)
 puts
 puts
  end

end