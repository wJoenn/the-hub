require "rails_helper"

RSpec.describe GithubReaction do
  let!(:gid) { 1 }
  let!(:github_user_id) { 1 }
  let!(:content) { "+1" }

  let!(:owner) do
    GithubUser.create(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository) do
    GithubRepository.create(gid: 1, full_name: "wJoenn/wJoenn", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release) do
    GithubRelease.create(
      gid: 1,
      name: "wJoenn v1.0.0",
      tag_name: "v1.0.0",
      html_url: "https://www.github.com",
      release_date: Time.current,
      repository:,
      author: owner
    )
  end

  let!(:reaction) { described_class.create(gid:, github_user_id:, content:, release:) }

  describe "associations" do
    it "belongs to a GithubRelease" do
      expect(reaction.release).to eq release
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(reaction).to be_persisted

      test_wrong_record(gid:, github_user_id:, content:)
      test_wrong_record(gid:, github_user_id:, release:)
      test_wrong_record(gid:, content:, release:)
    end

    it "validates the numericality of github_user_id" do
      test_wrong_record(gid:, github_user_id: -1, content:, release:)
      test_wrong_record(gid:, github_user_id: "a", content:, release:)
    end

    it "validates the value of content" do
      %w[+1 -1 confused eyes heart hooray laugh rocket].each do |c|
        expect(described_class.create(gid:, github_user_id:, content: c, release:)).to be_persisted
      end

      test_wrong_record(gid:, github_user_id:, content: "a", release:)
    end
  end

  private

  def test_wrong_record(params)
    record = GithubReaction.create(params)
    expect(record).not_to be_persisted
  end
end
