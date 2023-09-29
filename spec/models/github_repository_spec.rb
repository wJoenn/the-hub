require "rails_helper"

RSpec.describe GithubRepository do
  let!(:gid) { 1 }
  let!(:full_name) { "wJoenn/wJoenn" }
  let!(:name) { "wJoenn" }
  let!(:description) { "A repo" }

  let!(:owner) do
    GithubUser.create(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository_one) { described_class.create(gid:, full_name:, name:, description:, owner:) }
  let!(:repository_two) { described_class.create(gid: "1", full_name:, name:, description:, owner:, starred: false) }

  describe "associations" do
    it "has many GithubRelease" do
      release = GithubRelease.create!(
        gid: 1,
        name: "wJoenn v1.0.0",
        tag_name: "v1.0.0",
        html_url: "https://www.github.com",
        release_date: Time.current,
        repository: repository_one,
        author: owner
      )

      expect(repository_one.releases).to contain_exactly release
    end

    it "belongs to a GithubUser" do
      expect(repository_one.owner).to eq owner
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(repository_one).to be_persisted

      test_wrong_record(gid:, full_name:, name:, description:)
      test_wrong_record(gid:, full_name:, name:, owner:)
      test_wrong_record(gid:, full_name:, description:, owner:)
      test_wrong_record(gid:, name:, description:, owner:)
    end

    it "validates the booleanility of starred" do
      expect(repository_one).to be_starred
      expect(repository_two).not_to be_starred

      test_wrong_record(gid: 1, full_name:, name:, description:, owner:, starred: nil)
    end
  end

  private

  def test_wrong_record(params)
    record = GithubRepository.create(params)
    expect(record).not_to be_persisted
  end
end
