class Project < ApplicationRecord
  validates :title, :date, :description, presence: true

  belongs_to :user
  has_many :user_projects
  has_many :contributors, through: :user_projects, source: :user

  has_many :events, dependent: :destroy

  has_many :tasks, dependent: :destroy

  def self.create_project(current_user, project)
    transaction do
      begin
        project.save
        UserProject.create(user: current_user, project: project)
      rescue
        false
      end
    end
  end
end
