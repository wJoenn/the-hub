require "rails_helper"

RSpec.describe Github::Release do
  let!(:gid) { 1 }
  let!(:name) { "wJoenn v1.0.0" }
  let!(:tag_name) { "v1.0.0" }
  let!(:html_url) { "https://www.github.com" }
  let!(:released_at) { 1.day.ago }

  let!(:reaction) { create(:github_reaction, :with_release) }
  let!(:release_one) { create(:github_release, read: true) }
  let!(:release_two) { reaction.reactable }
  let!(:author) { release_one.author }
  let!(:repository) { release_one.repository }

  describe "associations" do
    it "has many Github::Reaction" do
      expect(release_two.reactions).to all be_a Github::Reaction
    end

    it "belongs to a Github::Repository" do
      expect(release_one.repository).to be_a Github::Repository
    end

    it "belongs to a Github::User" do
      expect(release_one.author).to be_a Github::User
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(release_one).to be_persisted

      test_wrong_record(gid:, name:, tag_name:, html_url:, released_at:, repository:)
      test_wrong_record(gid:, name:, tag_name:, html_url:, released_at:, author:)
      test_wrong_record(gid:, name:, tag_name:, html_url:, repository:, author:)
      test_wrong_record(gid:, name:, tag_name:, released_at:, repository:, author:)
      test_wrong_record(gid:, name:, released_at:, repository:, author:)
      test_wrong_record(gid:, tag_name:, released_at:, repository:, author:)
    end

    it "validates the booleanility of read" do
      expect(release_one).to be_read
      expect(release_two).not_to be_read

      test_wrong_record(gid:, name:, tag_name:, html_url:, released_at:, repository:, author:, read: nil)
    end

    it "validates the DateTime format of released_date" do
      test_wrong_record(gid:, name:, tag_name:, html_url:, released_at: "a", repository:, author:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
