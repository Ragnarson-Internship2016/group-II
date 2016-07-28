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

  context "when author does not take part in project" do
    subject { FactoryGirl.build(:event) }
    before { subject.author = FactoryGirl.build(:user) }

    it "is invalid" do
      expect(subject).to be_invalid
    end

    it "adds error message about author" do
      subject.validate
      expect(subject.errors.messages[:author].first)
        .to eql("must take part in project")
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


  context "#updates_and_notifies" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { event.project.user }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:different_user) { FactoryGirl.create(:user) }
    let(:message) { "#{event.class} - #{event.title} has been recently updated :* description was changed to wind of change" }

    before do
      UserProject.create(user: another_user, project: event.project)
      UserProject.create(user: different_user, project: event.project)
      params = event.attributes
      params["description"] = "wind of change"
      event.update_and_notify(params, user, :projects_contributors)
    end

    it "updates event record" do
      expect(event.description).to eql("wind of change")
    end

    it "sends notification to users that contribute to project it terms of which events exist" do
      expect(another_user.incoming_notifications)
        .to match_array(Notification.where(user: another_user, notificable: event))

      expect(different_user.incoming_notifications)
        .to match_array(Notification.where(user: different_user, notificable: event))
    end

    it "sends no notifications to the executor of action" do
      expect(user.incoming_notifications)
        .to match_array([])
    end

    it "notifies users with a proper message" do
      expect(different_user.incoming_notifications)
        .to match_array(Notification.where(user: different_user, notificable: event, message: message))

      expect(another_user.incoming_notifications)
        .to match_array(Notification.where(user: another_user, notificable: event, message: message))
    end
  end

  context "#saves_and_notifies" do
    let(:event) { FactoryGirl.build(:event) }
    let(:project) { event.project }
    let(:user) { project.user }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:message) { "There is a new #{event.class} - #{event.title}, check this out!" }

    before do
      UserProject.create(user: another_user, project: project)
      event.save_and_notify(user, :projects_contributors)
    end

    it "sends notification to users that are contributing to the project" do
      expect(another_user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: another_user, notificable: event))
    end

    it "sends no notifications to the author" do
      expect(user.incoming_notifications)
        .to be_empty
    end

    it "notifies users with a proper message" do
      expect(another_user.incoming_notifications.first.message)
        .to eq(message)
    end
  end

  context "#destroy and notify" do
    let(:event) { FactoryGirl.create(:event) }
    let(:author) { event.project.user }
    let(:user) { FactoryGirl.create(:user) }
    let(:message) { "#{event.class}  - #{event.title} has been removed." }

    before do
      UserProject.create(user: user, project: event.project)
      event.destroy_and_notify(author, :projects_contributors)
    end

    it "deletes event form db" do
      expect(Event.all).to eq([])
    end

    it "sends no notifications to the executor of delete action" do
      expect(author.incoming_notifications).to be_empty
    end

    it "sends proper notification to project contributors" do
      expect(user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: user, message: message))
    end

    it "notifies user with a proper message" do
      expect(user.incoming_notifications.first.message)
        .to eq(message)
    end
  end
end
