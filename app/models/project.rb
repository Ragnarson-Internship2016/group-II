class Project < ApplicationRecord
  validates :title, :date, :description, presence: true
end
