class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.boolean :read, default: false
      t.text :message
      t.references :user, index: true, foreign_key: true
      t.references :notificable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
