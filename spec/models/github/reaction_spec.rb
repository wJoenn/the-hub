require "rails_helper"

RSpec.describe Github::Reaction do
  let!(:gid) { 1 }
  let!(:github_user_id) { 1 }
  let!(:content) { "+1" }

  let!(:reaction) { create(:github_reaction, :with_release) }
  let!(:reactable) { reaction.reactable }

  describe "associations" do
    it "belongs to a Github::Release" do
      expect(reaction.reactable).to be_a Github::Release
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(reaction).to be_persisted

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
