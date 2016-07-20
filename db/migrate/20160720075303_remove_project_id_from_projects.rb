class RemoveProjectIdFromProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :project_id
  end
end
