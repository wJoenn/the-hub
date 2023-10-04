require "rails_helper"

RSpec.describe Github::Release do
  let!(:gid) { 1 }
  let!(:name) { "wJoenn v1.0.0" }
  let!(:tag_name) { "v1.0.0" }
  # let!(:html_url) { "https://www.github.com" }
  let!(:release_date) { Time.current }

  let!(:repository) { create(:github_repository) }
  let!(:release_one) { create(:github_release, repository:, read: true) }
  let!(:release_two) { create(:github_release) }

  describe "associations" do
    it "belongs to a GithubRepository" do
      expect(release_one.repository).to be_a Github::Repository
    end

    it "belongs to a GithubUser" do
      expect(release_one.author).to be_a Github::User
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(release_one).to be_persisted

      test_wrong_record(gid:, name:, tag_name:, release_date:)
      test_wrong_record(gid:, name:, tag_name:, repository:)
      test_wrong_record(gid:, name:, release_date:, repository:)
      test_wrong_record(gid:, tag_name:, release_date:, repository:)
    end

    it "validates the booleanility of read" do
      expect(release_one).to be_read
      expect(release_two).not_to be_read

      test_wrong_record(gid:, name:, tag_name:, release_date:, repository:, read: nil)
    end

    it "validates the DateTime format of released_date" do
      test_wrong_record(gid:, name:, tag_name:, release_date: "2023/10/01", repository:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
