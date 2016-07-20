class Task < ApplicationRecord
  validates :title, :description, :due_date, :done, presence: true 
end
