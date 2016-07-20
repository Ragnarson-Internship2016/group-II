class Task < ApplicationRecord
  validates :title, :description, :due_date, presence: true 
  validate :not_past_date

  def not_past_date
    if due_date && due_date < Date.today
      errors.add(:due_date, 'Date should not be in the past.')
    end
  end
end
