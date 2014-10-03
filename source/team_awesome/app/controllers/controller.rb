require_relative '../models/task'

module Controller
  def self.parse
    if ARGV[0].nil?
      View.menu
    else
      argument = ARGV
      command = argument.shift.downcase
      parameter = argument.join(" ")
      if command == "list"
        View.print(Task.all)
      elsif command == "add"
        Task.create(name: parameter)
        View.new_task_confirmation(parameter)
      elsif command == "delete"
        Task.find(parameter).destroy
        View.task_deleted_confirmation
      elsif command == "complete"
        task = Task.find(parameter)
        task.completed = true
        task.save
        View.task_completed_confirmation
      else
        View.error
      end
    end
  end
end

module View

  def self.menu
    puts "Welcome to The To Do App. Here's what you can do:"
    puts "list: View all tasks"
    puts "add <name of task>: Adds a task to your list"
    puts "delete <id of task>: Deletes a task from your list"
    puts "complete <id of task>: Marks a task as completed"
  end

  def self.print(tasks)
    count = 1
    tasks.each do |task|
      puts "#{count}. #{task.name} (ID: #{task.id}) - Completed: #{task.completed}"
      count += 1
    end
  end

  def self.new_task_confirmation(name)
    puts "You just added '#{name}' to your to do list!"
  end

  def self.task_deleted_confirmation
    puts "You just deleted a task."
  end

  def self.task_completed_confirmation
    puts "Way to go! Great job on completing a task!"
  end

  def self.error
    puts "I don't know that command. Try 'list', 'add', 'delete', or 'complete'."
  end

end