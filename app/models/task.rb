class Task < ApplicationRecord
  validates :title, :description, :due_date, presence: true
  validate :validate_due_date_not_in_past

  has_many :user_tasks, dependent: :destroy
  has_many :participants, through: :user_tasks, source: :user

  has_many :notifications, as: :notificable

  belongs_to :project

  scope :projects_with_not_done_tasks, -> { not_done.group_by(&:project) }
  scope :not_done, -> { where(done: false) }

  def update_and_notify params, current_user
    transaction do
      begin
        attributed_changed = attributes_to_be_changed(params)
        message = record_updated_message(attributed_changed)
        self.participants.each do |user|
          # next if user == current_user
          Notification.create!(user: user, notificable: self, message: message)
        end
        self.update!(params)
      rescue Exeption => e
        puts e
        false
      end
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
  def validate_due_date_not_in_past
    if due_date && due_date < Date.today
      errors.add(:due_date, "Date should not be in the past.")
    end
  end

  def attributes_to_be_changed future
    puts "Current attr: ", self.attributes
    puts "Attr passed through form", future.to_h
    # puts future.to_h["date"].to_datetime == self.attributes["date"].to_datetime
    a = future.to_h.delete_if do |k, v|
      v == self.attributes[k] || k == "updated_at" || (k =="due_date" && v.to_date == self.attributes["due_date"].to_date)
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
