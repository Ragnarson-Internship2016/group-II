require "rails_helper"

RSpec.describe Event, type: :model do
  subject { FactoryGirl.build(:event) }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  context "when params are valid" do
    it "contains reference to correct author" do
      expect(subject.author.id).to eql(subject.author_id)
    end

    it "contains reference to correct project" do
      expect(subject.project.id).to eql(subject.project_id)
    end
  end

  context "when author is not provided" do
    subject { FactoryGirl.build(:event, author_id: nil) }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when project is not provided" do
    subject { FactoryGirl.build(:event, project_id: nil) }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when title is not provided" do
    subject { FactoryGirl.build(:event, title: nil) }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when title is blank" do
    subject { FactoryGirl.build(:event, title: "") }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when date is not provided" do
    subject { FactoryGirl.build(:event, date: nil) }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end
end
