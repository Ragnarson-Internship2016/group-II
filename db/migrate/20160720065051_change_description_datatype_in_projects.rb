class ChangeDescriptionDatatypeInProjects < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :description, :text
  end
end
