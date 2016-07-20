class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.string :status
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
