require "rails_helper"

RSpec.describe Github::Repository do
  let!(:gid) { 1 }
  let!(:full_name) { "wJoenn/wJoenn" }
  let!(:name) { "wJoenn" }
  let!(:stargazers_count) { 1 }
  let!(:forks_count) { 1 }
  let!(:pushed_at) { 1.day.ago }
  let!(:html_url) { "https://www.github.com" }

  let!(:owner) { create(:github_user) }
  let!(:repository_one) { create(:github_repository) }
  let!(:repository_two) { create(:github_repository, starred: false) }

  describe "associations" do
    it "has many Github::Release" do
      create(:github_release, repository: repository_one)
      expect(repository_one.releases).to all be_a Github::Release
    end

    it "belongs to a Github::User" do
      expect(repository_one.owner).to be_a Github::User
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(repository_one).to be_persisted

      test_wrong_record(gid:, owner:, name:, full_name:, stargazers_count:, forks_count:, pushed_at:)
      test_wrong_record(gid:, owner:, name:, full_name:, stargazers_count:, forks_count:, html_url:)
      test_wrong_record(gid:, owner:, name:, full_name:, stargazers_count:, pushed_at:, html_url:)
      test_wrong_record(gid:, owner:, name:, full_name:, forks_count:, pushed_at:, html_url:)
      test_wrong_record(gid:, owner:, name:, stargazers_count:, forks_count:, pushed_at:, html_url:)
      test_wrong_record(gid:, owner:, full_name:, stargazers_count:, forks_count:, pushed_at:, html_url:)
      test_wrong_record(gid:, name:, full_name:, stargazers_count:, forks_count:, pushed_at:, html_url:)
    end

    it "validates the booleanility of starred" do
      expect(repository_one).to be_starred
      expect(repository_two).not_to be_starred

      test_wrong_record(
        gid: 1,
        full_name:,
        name:,
        stargazers_count:,
        forks_count:,
        pushed_at:,
        html_url:,
        owner:,
        starred: nil
      )
    end

    it "validates the numericality of stargazers_count" do
      test_wrong_record(gid:, owner:, name:, full_name:, stargazers_count: -1, forks_count:, pushed_at:, html_url:)
      test_wrong_record(gid:, owner:, name:, full_name:, stargazers_count: "a", forks_count:, pushed_at:, html_url:)
    end

    it "validates the numericality of forks_count" do
      test_wrong_record(gid:, owner:, name:, full_name:, forks_count: -1, stargazers_count:, pushed_at:, html_url:)
      test_wrong_record(gid:, owner:, name:, full_name:, forks_count: "a", stargazers_count:, pushed_at:, html_url:)
    end

    it "validates the DateTime format of pushed_at" do
      test_wrong_record(gid:, owner:, name:, full_name:, stargazers_count:, forks_count:, pushed_at: "a", html_url:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
