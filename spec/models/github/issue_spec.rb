require "rails_helper"

RSpec.describe Github::Issue do
  let!(:gid) { 1 }
  let!(:body) { "An issue" }
  let!(:status) { "opened" }
  let!(:title) { "This is an issue" }
  let!(:gh_type) { "Issue" }
  let!(:number) { 1 }
  let!(:html_url) { "https://www.github.com" }
  let!(:released_at) { Time.current }

  let!(:issue) { create(:github_issue) }
  let!(:repository) { issue.repository }
  let!(:author) { issue.author }

  describe "associations" do
    it "belongs to a Github::Repository" do
      expect(issue.repository).to be_a Github::Repository
    end

    it "belongs to a Github::User" do
      expect(issue.author).to be_a Github::User
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(issue).to be_persisted

      test_wrong_record(gid:, body:, status:, title:, gh_type:, number:, html_url:, released_at:, repository:)
      test_wrong_record(gid:, body:, status:, title:, gh_type:, number:, html_url:, released_at:, author:)
      test_wrong_record(gid:, body:, status:, title:, gh_type:, number:, html_url:, repository:, author:)
      test_wrong_record(gid:, body:, status:, title:, gh_type:, number:, released_at:, repository:, author:)
      test_wrong_record(gid:, body:, status:, title:, gh_type:, html_url:, released_at:, repository:, author:)
      test_wrong_record(gid:, body:, status:, title:, number:, html_url:, released_at:, repository:, author:)
      test_wrong_record(gid:, body:, status:, gh_type:, number:, html_url:, released_at:, repository:, author:)
      test_wrong_record(gid:, body:, title:, gh_type:, number:, html_url:, released_at:, repository:, author:)
      test_wrong_record(gid:, status:, title:, gh_type:, number:, html_url:, released_at:, repository:, author:)
    end

    it "validates the numericality of github_user_id" do
      test_wrong_record(
        gid:,
        body:,
        status:,
        title:,
        gh_type:,
        number: -1,
        html_url:,
        released_at:,
        repository:,
        author:
      )

      test_wrong_record(
        gid:,
        body:,
        status:,
        title:,
        gh_type:,
        number: "a",
        html_url:,
        released_at:,
        repository:,
        author:
      )
    end

    it "validates the DateTime format of released_at" do
      test_wrong_record(
        gid:,
        body:,
        status:,
        title:,
        gh_type:,
        number:,
        html_url:,
        released_at: "a",
        repository:,
        author:
      )
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
