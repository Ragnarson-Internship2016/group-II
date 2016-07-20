class Task < ApplicationRecord
  validates :title, :description, :due_date, presence: true 
end
