class RemoveDivisionColumn < ActiveRecord::Migration
  def change
    remove_column :employees, :division, :string
  end
end
