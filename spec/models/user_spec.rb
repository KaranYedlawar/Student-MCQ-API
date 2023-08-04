# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_one(:academic).dependent(:destroy) }
  it { should validate_presence_of(:role) }
  it { should define_enum_for(:role).with_values(student: "student", admin: "admin", teacher: "teacher") }

  describe "default role" do
    it "should have 'student' as the default role" do
      user = build(:user) # Use 'build' instead of 'create' to create an unsaved instance.
      expect(user.role).to eq("student")
    end
  end

  describe "jwt_payload" do
    it "should call super to include the default payload" do
      user = build(:user) # Use 'build' instead of 'create' to create an unsaved instance.
      expect(user).to receive(:super)
      user.jwt_payload
    end
  end

  describe "creation" do
    context "when valid attributes are provided" do
      it "should create a new user" do
        user = build(:user, role: "student") # Use 'build' to create an unsaved instance.
        expect(user.save).to be true
        expect(User.count).to eq(1)
      end
    end

    context "when required attributes are missing" do
      it "should not create a user without a role" do
        user = build(:user, role: nil) # Missing role intentionally.
        expect(user.save).to be false
        expect(user.errors.full_messages).to include("Role can't be blank")
        expect(User.count).to eq(0)
      end
    end
  end

  describe "destruction" do
    let!(:user) { create(:user) }

    it "should destroy the user and associated academic record" do
      academic = create(:academic, user: user)
      expect { user.destroy }.to change(User, :count).by(-1)
      expect { Academic.find(academic.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
