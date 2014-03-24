require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'employee'
require 'division'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(development_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Employee.all.each { |task| task.destroy}
  end
end
