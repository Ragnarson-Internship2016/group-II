class Project < ApplicationRecord
  validates :title, :date, :description, presence: { message: "must be given please" }
  validates :title, length: { maximum: 100, too_long: "%{count} characters is the maximum allowed" }
  validates :description, length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" }
end
