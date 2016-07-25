class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors[attribute] << (options[:message] || "must not be nil")
    elsif value <= Time.now
      record.errors[attribute] << (options[:message] || "must be in future")
    end
  end
end
