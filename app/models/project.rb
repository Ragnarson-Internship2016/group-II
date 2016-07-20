class Project < ApplicationRecord
  validates :title, :date, :description, presence: true
  belongs_to :user
end
