class Event < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project

  validates :title, :date, presence: true
  validates :date, future_date: true
end
