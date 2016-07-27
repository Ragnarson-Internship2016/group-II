class Event < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :project

  has_many :notifications, as: :notificable

  validates :title, :date, presence: true
  validates :date, future_date: true
  validate :author_must_take_part_in_project

  def update_and_notify params, current_user
    transaction do
      attributed_changed = attributes_to_be_changed(params)
      message = record_updated_message(attributed_changed)
      self.project.contributors.each do |user|
        # next if user == current_user
        Notification.create!(user: user, notificable: self, message: message)
      end
      self.update!(params)
    end
  end

  def save_and_notify current_user
    transaction do
      message = record_created_message
      self.project.contributors.each do |user|
        # next if user == current_user
        Notification.create!(user: user, notificable: self, message: message)
      end
      self.save
    end
  end

  def destroy_and_notify current_user
    transaction do
      message = record_deleted_message
      self.project.contributors.each do |user|
        # next if user == current_user
        Notification.create!(user: user, notificable: self, message: message)
      end
      self.destroy!
    end
  end

  private

  def author_must_take_part_in_project
    unless author && author.takes_part_in_project?(project_id)
      errors.add(:author, "must take part in project")
    end
  end

  def attributes_to_be_changed future
    puts "Current attr: ", self.attributes
    puts "Attr passed through form", future.to_h
    # puts future.to_h["date"].to_datetime == self.attributes["date"].to_datetime
    a = future.to_h.delete_if do |k, v|
      v == self.attributes[k] || k == "updated_at" || (k =="date" && v.to_date == self.attributes["date"].to_date)
    end
  end

  def record_deleted_message
    "#{self.class}  - #{self.title} has been removed"
  end

  def record_updated_message(attributes)
    message = "#{self.class} #{self.title} has been recently updated :"
    attributes.each do |key, val|
      message += "\n* " + key.to_s + " was changed to " + val.to_s
    end
    message
  end

  def record_created_message
    "There is a new #{self.class} - #{self.title}, check this out"
  end
end

