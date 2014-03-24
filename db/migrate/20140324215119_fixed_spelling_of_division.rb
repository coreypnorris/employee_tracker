class FixedSpellingOfDivision < ActiveRecord::Migration
  def change
    remove_column :employees, :divsion_id, :integer
    add_column :employees, :division_id, :integer
  end
end
