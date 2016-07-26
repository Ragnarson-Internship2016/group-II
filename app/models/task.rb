class Task < ApplicationRecord
  validates :title, :description, :due_date, presence: true
  validate :validate_due_date_not_in_past

  has_many :user_tasks, dependent: :destroy
  has_many :participants, through: :user_tasks, source: :user

  has_many :notifications, as: :notificable

  belongs_to :project

  scope :projects_with_not_done_tasks, -> { not_done.group_by(&:project) }
  scope :not_done, -> { where(done: false) }

  private
  def validate_due_date_not_in_past
    if due_date && due_date < Date.today
      errors.add(:due_date, "Date should not be in the past.")
    end
  end
end
