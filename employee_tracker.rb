require 'active_record'

require './lib/division'
require './lib/employee'

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
    puts "Press 'd' to to the divisions menu"
    puts "Press 'e' to exit the program."
    choice = gets.chomp
    case choice
    when 'e'
      employees
    when 'd'
      divisions
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
  puts "Enter 'd' to delete an employee"
  puts "Enter 'b' to go back"
  input = gets.chomp
  case input
  when 'a'
    add_employee
  when 'v'
    list_employees
  when 'd'
    delete_employees
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
  # if Division.all.length <= 0
  #   puts "Create a division first."
  # end
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

welcome













