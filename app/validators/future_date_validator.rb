class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors[attribute] << (options[:message] || "date is nil")
    elsif value <= Time.now
      record.errors[attribute] << (options[:message] || "date not in future")
    end
  end
end
