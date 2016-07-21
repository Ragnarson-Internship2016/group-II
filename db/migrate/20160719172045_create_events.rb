class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :date, null: false
      t.integer :author_id, references: :users, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
