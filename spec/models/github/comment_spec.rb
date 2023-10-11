require "rails_helper"

RSpec.describe Github::Comment do
  let!(:gid) { 1 }
  let!(:html_url) { "https://www.github.com" }
  let!(:released_at) { 1.day.ago }

  let!(:reaction) { create(:github_reaction, :with_comment) }
  let!(:comment) { reaction.reactable }
  let!(:issue) { comment.issue }
  let!(:author) { comment.author }

  describe "associations" do
    it "has one FeedItem" do
      expect(comment.feed_item).to be_a FeedItem
    end

    it "has many Github::Reaction" do
      expect(comment.reactions).to all be_a Github::Reaction
    end

    it "belongs to a Github::Issue" do
      expect(comment.issue).to be_a Github::Issue
    end

    it "belongs to a Github::User" do
      expect(comment.author).to be_a Github::User
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(issue).to be_persisted

      test_wrong_record(gid:, html_url:, released_at:, issue:)
      test_wrong_record(gid:, html_url:, released_at:, author:)
      test_wrong_record(gid:, html_url:, issue:, author:)
      test_wrong_record(gid:, released_at:, issue:, author:)
    end

    it "validates the booleanility of read" do
      expect(comment).not_to be_read

      comment.update(read: true)
      expect(comment).to be_read

      test_wrong_record(gid:, html_url:, released_at: "a", issue:, author:, read: nil)
    end

    it "validated that the feed_type cannot be changed" do
      test_wrong_record(gid:, html_url:, released_at:, issue:, author:, feed_type: "a")
    end

    it "validates the DateTime format of released_at" do
      test_wrong_record(gid:, html_url:, released_at: "a", issue:, author:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
