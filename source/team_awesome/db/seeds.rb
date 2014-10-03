require 'faker'
require_relative '../app/models/task'

10.times do
  Task.create(name: Faker::Hacker.say_something_smart)
end