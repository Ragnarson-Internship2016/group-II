class Task < ApplicationRecord
  validates :title, :description, :due_date, presence: true 
  validate :validate_due_date_not_in_past

  def validate_due_date_not_in_past
   if due_date && due_date < Date.today
      errors.add(:due_date, "Date should not be in the past.")
    end
  end
end
