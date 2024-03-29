require 'active_record'

require './lib/division'
require './lib/employee'
require './lib/project'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the Employee Tracker"
  menu
end

def menu
  choice = nil
  until choice == 'e'
    puts "Press 'e' to go to the employee menu."
    puts "Press 'd' to go the divisions menu"
    puts "Press 'p' to go to the projects menu"
    puts "Press 'e' to exit the program."
    choice = gets.chomp
    case choice
    when 'e'
      employees
    when 'd'
      divisions
    when 'p'
      projects
    when 'e'
      puts "goodbye!"
    else
      puts "Sorry, that wasn't a valid option"
    end
  end
end
def employees
  puts "Enter 'a' to add a new employee"
  puts "Enter 'v' to view current employees"
  # puts "Enter 'p' to view a particular employeed"
  puts "Enter 'd' to delete an employee"
  puts "Enter 'b' to go back"
  input = gets.chomp
  case input
  when 'a'
    add_employee
  when 'v'
    list_employees
  when 'd'
    delete_employee
  when 'b'
    menu
  else
    puts "that isn't a valid option"
  end
end
def divisions
  puts "Enter 'a' to create a new division"
  puts "Enter 'v' to view current divisions, and employees associated with each division"
  puts "Enter 'd' to delete a division"
  puts "Enter 'b' to go back"
  input = gets.chomp
  case input
  when 'a'
    create_division
  when 'v'
    list_divisions
  when 'd'
    delete_divisions
  when 'b'
    puts menu
  else
    puts "That isn't a valid option"
  end
end
def add_employee
  puts "What is the name of the new employee?"
  name = gets.chomp
  puts "What division does the employee belong too?"
  division_list = Division.all
  division_list.each do |division| puts division.name
  end
  division_name = gets.chomp
  division_id = Division.find_by name: division_name
  employee = Employee.new({:name => name, :division_id => division_id.id})
  employee.save
  puts "'#{name}' has been saved do the database"
  puts "Would you like to go back to the main menu? 'y' or 'n'"
  input = gets.chomp
  case input
  when 'y'
    menu
  when 'n'
    puts "Goodbye!"
  else
    puts "That isn't a valid option"
  end

end

def list_employees
  puts "Here are all current employees"
  employees = Employee.all
  employees.each { |employee| puts employee.name}
  puts "Would you like to go back to the main menu? 'y' or 'n'"
  input = gets.chomp
  case input
  when 'y'
    menu
  when 'n'
    puts "Goodbye!"
  else
    puts "That isn't a valid option"
  end
end

def create_division
  puts "What is the name of the division you would like to create?"
  division_name = gets.chomp
  division = Division.new(:name => division_name)
  division.save
  puts "**** '#{division.name}', has been added to the list ****"
  list_divisions
end

def list_divisions
  puts "Here are all current divisions:"
  list = Division.all
  list.each { |division| puts division.name}
  puts "Select a division to view its employees"
  division_choice = gets.chomp
  select_division = Division.where({:name => division_choice}).first
  select_division.employees.each { |employee| puts employee.name }
end

def projects
  puts "Press 'a' to add a new project"
  puts "Press 'v' to view current projects and employees working on them"
  puts "Press 'e' to add an employee to a project"
  puts "Press 'c' to complete a project"
  puts "press 'd' to delete a project"
  puts "press 'b' to go back"
  input = gets.chomp
  case input
  when 'a'
    new_project
  when 'v'
    view_projects
  when 'b'
    menu
  when 'e'
    add_employee
  when 'c'
    complete_project
  when 'd'
    delete_project
  else
    puts "That isn't a valid option"
  end
end

def new_project
  puts "Enter the name of the new project"
  name_input = gets.chomp
  puts "Entere the description of the project"
  describe_input = gets.chomp
  project = Project.new(:name => name_input, :description => describe_input)
  project.save
  puts "'#{name_input}' has been added to the project list"
  projects
end

def view_projects
  project_list = Project.all
  project_list.each { |projects| puts projects.name + ": " + projects.description + "\n\n" }
  puts "Select a project to view its employees"
  project_choice = gets.chomp
  select_project = Project.where({:name => project_choice}).first
  select_project.employees.each { |employee| puts employee.name}
  puts "Would you like to go back to the main menu? 'y' or 'n'"
  input = gets.chomp
  case input
  when 'y'
    menu
  when 'n'
    puts "Goodbye!"
  else
    puts "That is not a valid option"
  end
end

def add_employee
  puts "Choose your project to add an employee too"
  project_list = Project.all
  project_list.each { |projects| puts projects.name}
  project_input = gets.chomp
  project_id = Project.find_by name: project_input
  puts "Choose an employee to add to the project '#{project_input}'"
  employee_list = Employee.all
  employee_list.each { |employees| puts employees.name}
  employee_input = gets.chomp
  employee = Employee.where({:name => employee_input}).first
  employee.update({:project_id => project_id.id})
  puts "'#{employee_input}' has been added to '#{project_input}' "
  menu
end

def complete_project
  puts "Which project would you like to complete?"
  Project.all.each_with_index do |project, index|
    puts "#{index+1}) '#{project.name}'"
  end
  project_to_complete = gets.chomp.to_i
  Project.all[project_to_complete-1].update_attributes(:done => false)
  completed_project = Project.all[project_to_complete-1]
  puts "'#{completed_project.done}'"
end

def delete_project
  puts "Which project would you like to delete"
  Project.all.each_with_index do |project, index|
    puts "#{index+1}) '#{project.name}'"
  end
  project_to_delete = gets.chomp.to_i
  Project.all[project_to_delete-1].destroy
  puts "The project has been deleted."
end

def delete_divisions
  puts "Which division would you like to delete"
  Division.all.each_with_index do |division, index|
    puts "#{index+1}) '#{division.name}'"
  end
  division_to_delete = gets.chomp.to_i
  Division.all[division_to_delete-1].destroy
  puts "The division has been deleted."
  menu
end

def delete_employee
  puts "Which employee would you like to delete?"
  Employee.all.each_with_index do |employee, index|
    puts "#{index+1}) '#{employee.name}'"
  end
  employee_to_delete = gets.chomp.to_i
  Employee.all[employee_to_delete-1].destroy
  puts "The employee has been deleted."
  menu
end





welcome













