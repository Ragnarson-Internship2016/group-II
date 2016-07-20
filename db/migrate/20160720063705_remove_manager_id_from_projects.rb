class RemoveManagerIdFromProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :manager_id
  end
end
