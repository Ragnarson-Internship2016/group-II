module NotificationMethods

  def save_and_notify(current_user, target)
    transaction do
      begin
        self.save!
        message = record_created_message
        deliver_notification(target, message, current_user)
      rescue
        false
      end
    end
  end

  def update_and_notify(params, current_user, target)
    transaction do
      begin
        self.update!(params)
        attributes_changed = self.previous_changes
        attributes_changed.delete("updated_at")
        puts attributes_changed.to_s
        message = record_updated_message(attributes_changed)
        !attributes_changed.empty? ? deliver_notification(target, message, current_user) : true
      rescue
        false
      end
    end
  end

  def destroy_and_notify(current_user, target)
    transaction do
      begin
        message = record_deleted_message
        deliver_notification(target, message, current_user)
        self.destroy!
      rescue
        false
      end
    end
  end

  def deliver_notification(target, message, current_user)
    self.public_send(target).each do |user|
      next if user == current_user
      Notification.create!(user: user, notificable: self, message: message)
    end
  end

  def record_deleted_message
    "#{self.class}  - #{self.title} has been removed."
  end

  def record_updated_message(attributes)
    message = "#{self.class} - #{self.title} has been recently updated :"
    attributes.each do |key, val|
      message += "* " + key.to_s + " was changed to " + val[1].to_s
    end
    message
  end

  def record_created_message
    "There is a new #{self.class} - #{self.title}, check this out!"
  end
end
