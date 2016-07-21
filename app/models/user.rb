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
end
