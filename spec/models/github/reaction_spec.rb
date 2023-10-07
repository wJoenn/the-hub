require "rails_helper"

RSpec.describe Github::Reaction do
  let!(:gid) { 1 }
  let!(:github_user_id) { 1 }
  let!(:content) { "+1" }

  let!(:comment_reaction) { create(:github_reaction, :with_comment) }
  let!(:issue_reaction) { create(:github_reaction, :with_issue) }
  let!(:release_reaction) { create(:github_reaction, :with_release) }
  let!(:reactable) { release_reaction.reactable }

  describe "associations" do
    context "with polymorphism" do
      it "can belong to a Github::Comment" do
        expect(comment_reaction.reactable).to be_a Github::Comment
      end

      it "can belong to a Github::Issue" do
        expect(issue_reaction.reactable).to be_a Github::Issue
      end

      it "can belong to a Github::Release" do
        expect(release_reaction.reactable).to be_a Github::Release
      end
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(release_reaction).to be_persisted

      test_wrong_record(gid:, github_user_id:, content:)
      test_wrong_record(gid:, github_user_id:, reactable:)
      test_wrong_record(gid:, content:, reactable:)
    end

    it "validates the numericality of github_user_id" do
      test_wrong_record(gid:, github_user_id: -1, content:, reactable:)
      test_wrong_record(gid:, github_user_id: "a", content:, reactable:)
    end

    it "validates the value of content" do
      %w[+1 -1 confused eyes heart hooray laugh rocket].each do |c|
        expect(described_class.create(gid:, github_user_id:, content: c, reactable:)).to be_persisted
      end

      test_wrong_record(gid:, github_user_id:, content: "a", reactable:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
