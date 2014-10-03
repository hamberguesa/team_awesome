require_relative '../models/ingredient'
require 'yummly'

module Model
  def self.all_ingredients
    Ingredient.all
  end

  def self.format_search_terms(array)
    query = []
    array.each do |id|
      query <<Ingredient.find(id.to_i).name
    end
    query.join(", ")
  end

  def self.query(string)
    results = Yummly.search(string)
    parsed = results.matches[0..4]
  end

  def self.get_recipe_names(parsed_recipes)
    recipes = {}
    parsed_recipes.each do |recipe|
      recipes.merge!(recipe["id"] => recipe["recipeName"] )
    end
    recipes
  end

end

module Controller
  def self.run
    View.display_pantry(Model.all_ingredients)
    answer = View.options.downcase.split(" ")
    command = answer.shift
    case command
    when 'cook'
      parsed = Model.query(Model.format_search_terms(answer))
      View.display_result_recipes(Model.get_recipe_names(parsed))
    end
  end
end

module View
  def self.display_pantry(results)
    puts 'You currently have the following ingredients in your pantry:'
    results.each do |object|
      puts "#{object.id}. #{object.name} - Expires #{object.expiration_date}"
    end
  end

  def self.options
    puts 'Please choose from one of the following options:'
    puts '1. To add an ingredient, type \'add\'.'
    puts '2. To delete an ingredient, type \'delete\' followed by the number of the ingredient you would like to remove.'
    puts '3. To see possible recipes, type \'cook\' followed by 3 ingredients you would like to use.'
    gets.chomp
  end

  def self.display_result_recipes(recipe_hash)
    puts 'Here is what you can cook!'
    counter = 1
    recipe_hash.each_value do |name|
      puts "#{counter}. #{name}"
      counter += 1
    end
  end
end

# module Controller

#   def self.run
#     View.menu
#     command = gets.chomp.downcase
#     if command == "list all"
#       answer = View.which_list.downcase
#       if answer == "all"
#         View.print(Task.all)
#       else
#         View.print(Task.where(list_id: answer))
#       end
#     elsif command == "list outstanding"
#       tasks = Task.all.sort { |task1, task2| task1.due_date <=> task2.due_date }
#       tasks.reject! { |task| task.completed == true}
#       View.print(tasks)
#     elsif command == "list completed"
#       tasks = Task.all.sort { |task1, task2| task1.due_date <=> task2.due_date }
#       tasks.reject! { |task| task.completed == false}
#       View.print(tasks)
#     elsif command == "list by tag"
#       tag = View.which_tag.to_i
#       tasks = []
#       Task.all.each do |task|
#         if task.tag_ids.include?(tag)
#           tasks << task
#         end
#       end
#       View.print(tasks)
#     elsif command == "add list"
#       list = List.create(name: View.what)
#       View.new_list_confirmation(list.name)
#     elsif command == "add task"
#       list = View.which_list.downcase
#       task = Task.create(name: View.what, list_id: list)
#       View.new_task_confirmation(task.name)
#     elsif command == "add tag"
#       id = View.which_task
#       tag = View.which_tag
#       task = Task.find(id).tags
#       task << Tag.find(tag)
#       View.tag_confirmation(id, tag)
#     elsif command == "delete list"
#       list = View.which_list
#       List.find(list).tasks.each do |task|
#         task.destroy
#       end
#       List.find(list).destroy
#       View.deleted_confirmation
#     elsif command == "delete task"
#       Task.find(View.which_task).destroy
#       View.deleted_confirmation
#     elsif command == "complete"
#       task = Task.find(View.which_task)
#       task.completed = true
#       task.save
#       View.task_completed_confirmation
#     else
#       View.error
#     end
#   end
# end

# module View

#   def self.menu
#     puts "Welcome to The To Do App. Here's what you can do:"
#     puts "-------------------------------------------------"
#     puts "list all: View all tasks from one or all of your lists"
#     puts "list outstanding: View outstanding tasks sorted by due date"
#     puts "list completed: View completed tasks sorted by completed date"
#     puts "list by tag: View all tasks associated with a tag"
#     puts "-------------------------------------------------"
#     puts "add list: Adds a new todo list"
#     puts "add task: Adds a task to one of your lists"
#     puts "add tag: Adds a tag to one of your tasks"
#     puts "-------------------------------------------------"
#     puts "delete list: Deletes a list"
#     puts "delete task: Deletes a task from one of your lists"
#     puts "-------------------------------------------------"
#     puts "complete: Marks a task as completed"
#     puts "-------------------------------------------------"
#   end

#   def self.print(tasks)
#     count = 1
#     puts "-------------------------------------------------"
#     tasks.each do |task|
#       puts "#{count}. #{task.name} (ID: #{task.id}) - Due Date: #{task.due_date} | Completed: #{task.completed}"
#       count += 1
#     end
#   end

#   def self.which_list
#     puts "Which list?"
#     puts "-------------------------------------------------"
#     List.all.each do |list|
#       puts "#{list.name} (ID: #{list.id})"
#     end
#       puts "all"
#     gets.chomp
#   end

#   def self.which_task
#     puts "Which task?"
#     puts "-------------------------------------------------"
#     Task.all.each do |task|
#       puts "#{task.name} (ID: #{task.id})"
#     end
#     gets.chomp
#   end

#   def self.which_tag
#     puts "Which tag?"
#     puts "-------------------------------------------------"
#     Tag.all.each do |tag|
#       puts "#{tag.name} (ID: #{tag.id})"
#     end
#     gets.chomp
#   end

#   def self.what
#     puts "What would you like to add?"
#     puts "-------------------------------------------------"
#     gets.chomp
#   end

#   def self.new_task_confirmation(name)
#     puts "You just added '#{name}' to your to do list!"
#     puts "-------------------------------------------------"
#   end

#   def self.new_list_confirmation(name)
#     puts "You just added '#{name}' as a new list!"
#     puts "-------------------------------------------------"
#   end

#   def self.deleted_confirmation
#     puts "Deleted!"
#     puts "-------------------------------------------------"
#   end

#    def self.tag_confirmation(task, tag)
#     puts "Tagged #{Task.find(task).name} with #{Tag.find(tag).name}"
#     puts "-------------------------------------------------"
#   end

#   def self.task_completed_confirmation
#     puts "Way to go! Great job on completing a task!"
#     puts "-------------------------------------------------"
#   end

#   def self.error
#     puts "I don't know that command. Try 'list', 'add task', 'add list', 'delete task', 'delete list' or 'complete'."
#     puts "-------------------------------------------------"
#   end

# end