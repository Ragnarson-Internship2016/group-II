class Task < ApplicationRecord
  include NotificationMethods

  validates :title, :description, :due_date, presence: true
  validates :due_date, future_date: true

  has_many :user_tasks, dependent: :destroy
  has_many :participants, through: :user_tasks, source: :user

  has_many :notifications, as: :notificable

  belongs_to :project

  scope :projects_with_not_done_tasks, -> { not_done.group_by(&:project) }
  scope :not_done, -> { where(done: false) }
  scope :done, -> { where(done: true) }

  def projects_contributors
    project.contributors
  end
end
