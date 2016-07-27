class Notification < ApplicationRecord
  belongs_to :notificable, polymorphic: true
  belongs_to :user
end
