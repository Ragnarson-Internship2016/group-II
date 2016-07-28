class Notification < ApplicationRecord
  belongs_to :notificable, polymorphic: true
  belongs_to :user

  scope :not_read, -> { where(read: false) }
end
