class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, :surname, presence: true

  has_many :managed_projects, class_name: "Project"
  has_many :user_projects
  has_many :contributed_projects, through: :user_projects, source: :project

  has_many :user_tasks
  has_many :assigned_tasks, through: :user_tasks, source: :task

  has_many :events, foreign_key: "author_id", dependent: :destroy

  def takes_part_in_project?(project_id)
    projects.any? { |project| project.id == project_id }
  end

  def projects
    managed_projects + contributed_projects
  end
end
