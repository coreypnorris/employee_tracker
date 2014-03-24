class AddDivisionIdToEmployeesTable < ActiveRecord::Migration
  def change
    add_column :employees, :divsion_id, :integer
  end
end
