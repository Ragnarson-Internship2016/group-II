class Notification < ApplicationRecord
  belongs_to :notificable, polymorphic: true
end
