class Project < ApplicationRecord
  validates :title, :date, :description, presence: true

  belongs_to :user
  has_many :user_projects
  has_many :contributors, through: :user_projects, source: :user

  has_many :events

  has_many :tasks, dependent: :destroy
end
