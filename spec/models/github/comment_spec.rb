require "rails_helper"

RSpec.describe Github::Comment do
  let!(:gid) { 1 }
  let!(:body) { "An comment" }
  let!(:html_url) { "https://www.github.com" }
  let!(:released_at) { 1.day.ago }

  let!(:comment) { create(:github_comment) }
  let!(:issue) { comment.issue }
  let!(:author) { comment.author }

  describe "associations" do
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

      test_wrong_record(gid:, body:, html_url:, released_at:, issue:)
      test_wrong_record(gid:, body:, html_url:, released_at:, author:)
      test_wrong_record(gid:, body:, html_url:, issue:, author:)
      test_wrong_record(gid:, body:, released_at:, issue:, author:)
      test_wrong_record(gid:, html_url:, released_at:, issue:, author:)
    end

    it "validates the booleanility of read" do
      expect(comment).not_to be_read

      comment.update(read: true)
      expect(comment).to be_read

      test_wrong_record(gid:, body:, html_url:, released_at: "a", issue:, author:, read: nil)
    end

    it "validates the DateTime format of released_at" do
      test_wrong_record(gid:, body:, html_url:, released_at: "a", issue:, author:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
