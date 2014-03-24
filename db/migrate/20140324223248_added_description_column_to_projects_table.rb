class AddedDescriptionColumnToProjectsTable < ActiveRecord::Migration
  def change
    add_column :projects, :description, :string
  end
end
