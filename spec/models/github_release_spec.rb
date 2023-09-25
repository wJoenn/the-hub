require "rails_helper"

RSpec.describe GithubRelease do
  let!(:gid) { 1 }
  let!(:name) { "wJoenn v1.0.0" }
  let!(:tag_name) { "v1.0.0" }
  let!(:release_date) { Time.current }

  let!(:owner) do
    GithubUser.create(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository) do
    GithubRepository.create(gid: 1, full_name: "wJoenn/wJoenn", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release_one) { described_class.create(gid:, name:, tag_name:, release_date:, repository:, author: owner) }
  let!(:release_two) do
    described_class.create(gid: "1", name:, tag_name:, release_date:, repository:, read: true, author: owner)
  end

  describe "associations" do
    it "belongs to a GithubRepository" do
      expect(release_one.repository).to eq repository
    end

    it "belongs to a GithubUser" do
      expect(release_one.author).to eq owner
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
      expect(release_one).not_to be_read
      expect(release_two).to be_read

      test_wrong_record(gid:, name:, tag_name:, release_date:, repository:, read: nil)
    end
  end

  private

  def test_wrong_record(params)
    record = GithubRelease.create(params)
    expect(record).not_to be_persisted
  end
end
