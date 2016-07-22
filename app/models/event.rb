class Event < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project

  validates :title, :date, presence: true
  validates :date, future_date: true
  validate :author_must_take_part_in_project

  private
  def author_must_take_part_in_project
    unless author && author.takes_part_in_project?(project_id)
      errors.add(:author, "must take part in project")
    end
  end
end
