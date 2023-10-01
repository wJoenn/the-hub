require "rails_helper"

RSpec.describe GithubUser do
  let!(:gid) { 1 }
  let!(:login) { "wJoenn" }
  let!(:gh_type) { "User" }
  let!(:avatar_url) { "wJoenn/avatar" }
  let!(:html_url) { "wJoenn/html" }

  let!(:user) { create(:github_user) }

  describe "associations" do
    it "has many GithubRelease" do
      create(:github_release, author: user)
      expect(user.releases).to all be_a GithubRelease
    end

    it "has many GithubRepository" do
      create(:github_repository, owner: user)
      expect(user.repositories).to all be_a GithubRepository
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(user).to be_persisted

      test_wrong_record(gid:, login:, gh_type:, avatar_url:)
      test_wrong_record(gid:, login:, gh_type:, html_url:)
      test_wrong_record(gid:, login:, gh_type: nil, avatar_url:, html_url:)
      test_wrong_record(gid:, gh_type:, avatar_url:, html_url:)
    end
  end

  private

  def test_wrong_record(params)
    record = GithubUser.create(params)
    expect(record).not_to be_persisted
  end
end
