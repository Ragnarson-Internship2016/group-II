class Project < ApplicationRecord
  include NotificationMethods

  validates :title, :date, :description, presence: true
  validates :date, future_date: true

  belongs_to :user
  has_many :user_projects, dependent: :destroy
  has_many :contributors, through: :user_projects, source: :user

  has_many :events, dependent: :destroy

  has_many :tasks, dependent: :destroy

  has_many :notifications, as: :notificable

  def create_project(current_user)
    transaction do
      begin
        UserProject.create!(user: current_user, project: self)
        self.save!
      rescue
        false
      end
    end
  end
end
