# Activerecord Todos Part 2 
 
##Learning Competencies 

##Summary 

 Now that you have a working TODO app, it's time to exercise your Active Record Associations muscles and add in support for multiple lists.  For example a list for work TODOs , home TODOs, DBC TODOs.

[Here's a skeleton app](http://cl.ly/3u1L1M0B3q3E) that will be helpful, if you didn't use it for the first part of this challenge.

## Objectives

### Design the Schema for supporting multiple lists.

Here are some requirements for multiple lists:

1. As a user, I can view all my lists.  
2. As a user, I can add a new list.  
3. As a user, I can add/delete/complete a task in a particular list.  

What other requirements should you consider? 

Think through all possible user scenarios and then refactor your database schema so you can implement each scenario with your table structure. 

What tables do you need to add / alter in your database to make this work?

**NOTE:** Have a teacher review your design before you go to code.

### Create and run the schema migrations to build your database.

Can you do this without dumping your data from TODO Part 1?
Do you need any validations? 

### Populate your database with some initial data 
 
Use Faker (or another method of your choice) to create some seed data for your lists.

### Update the interface and controller
 
Add commands to the interface so a user can interact with multiple lists.  Try to make your interface easy and intuitive for a user to interact with.  (ie add a --help command).


### Additional Functionality

Now that we have a working TODO app with multiple lists, let's add three new commands to our TODO app.


In English, these correspond to the following user stories:

1. As a user, I want to list all my outstanding tasks sorted by *creation* date.
2. As a user, I want to list all my completed tasks sorted by *completion* date.
3. As a user, I want to tag tasks, e.g., home, work, errand, etc.
4. As a user, I want to list all tasks with a particular tag sorted by *creation* date.


#### Implement the outstanding command   for a chosen list::

Implement a command that works like

```text
$ ruby todo.rb list:outstanding
```

This should display a list of outstanding tasks sorted by *completion date*.

#### Implement the completed command for a chosen list:

Implement a command that works like


```text
$ ruby todo.rb list:completed
```

This should display a list of outstanding tasks sorted by *completion date*.  

#### Implement the tag command for a given task and list

Implement a command that works like

```text
$ ruby todo.rb list
1. Eat some pie
2. Walk the dog

$ ruby todo.rb tag 2 personal pet-care
Tagging task "Walk the dog" with tags: personal, pet-care
```

Each task can have multiple tags, so you'll have to change your table format to accomodate that.  You need to balance your preferences as a developer with the user's preferences when doing this.

#### Implement the filter command

Implement a `filter` command that works like

```text
$ ruby todo.rb list
1. Eat some pie
2. Walk the dog

$ ruby todo.rb tag 2 personal pet-care
Tagging task "Walk the dog" with tags: personal, pet-care

$ ruby todo.rb filter:personal
2. Walk the dog [personal]
``` 

##Releases
###Release 0 

##Optimize Your Learning 

##Resources