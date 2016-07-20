class Project < ApplicationRecord
  validates :title, :date, :description, presence: { message: "must be given please" }
end
