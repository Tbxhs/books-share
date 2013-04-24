# https://github.com/ryanb/cancan/wiki/Testing-Abilities
require 'spec_helper'
require "cancan/matchers"

describe Ability do
  context "when user has not signed in" do
    subject(:ability) {Ability.new nil}
    it "can Read All" do
      ability.should be_able_to(:read, :all)
    end

    it "can not create book and resource" do
      ability.should_not be_able_to(:create, Book)
      ability.should_not be_able_to(:create, Resource)
    end
  end

  it "when user has signed in with a admin role" do
    ability = Ability.new(create :admin_user)
    ability.should be_able_to(:manage, :all)
  end

  context "when user has signed in with a member role" do
    let(:member) { create :member_user }
    subject { Ability.new(member) }

    it { should be_able_to(:create, Book) }
    it { should be_able_to(:create, Resource) }
    it { should be_able_to(:manage, Attachment) }

    context "can not update and destroy the thing belongs to others" do
      it { should_not be_able_to(:update, Book.new) }
      it { should_not be_able_to(:destroy, Book.new) }
      it { should_not be_able_to(:update, Resource.new) }
      it { should_not be_able_to(:destroy, Resource.new) }
    end

    context "can update and destroy the thing belongs to him" do
      it { should be_able_to(:update, member.books.new) }
      it { should be_able_to(:destroy, member.books.new) }
      it { should be_able_to(:update, member.resources.new) }
      it { should be_able_to(:destroy, member.resources.new) }
    end
  end
end