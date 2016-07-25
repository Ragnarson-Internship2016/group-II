require "rails_helper"

class Validatable
  include ActiveModel::Validations
  attr_accessor :date
  validates :date, future_date: true
end

RSpec.describe FutureDateValidator do
  subject { Validatable.new }

  context "when date is nil" do
    it "is invalid" do
      expect(subject).to be_invalid
    end

    it "adds error message about nil" do
      subject.validate
      expect(subject.errors.messages[:date].first).to eql("must not be nil")
    end
  end

  context "when date is in the past" do
    before { subject.date = Faker::Time.backward(2) }

    it "is invalid" do
      expect(subject).to be_invalid
    end

    it "adds error message about the past date" do
      subject.validate
      expect(subject.errors.messages[:date].first).
        to eql("must be in future")
    end
  end

  context "when date is in the future" do
    before { subject.date = Faker::Time.forward(2) }

    it "is invalid" do
      expect(subject).to be_valid
    end
  end
end
