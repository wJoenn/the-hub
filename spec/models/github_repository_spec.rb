require "rails_helper"

RSpec.describe GithubRepository do
  let!(:github_id) { 1 }
  let!(:full_name) { "wJoenn/wJoenn" }
  let!(:name) { "wJoenn" }
  let!(:description) { "a_repo" }
  let!(:owner) do
    GithubUser.create(github_id: 1, login: "wJoenn", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository_one) do
    described_class.create(github_id:, full_name:, name:, description:, owner:)
  end

  let!(:repository_two) do
    described_class.create(github_id: "1", full_name:, name:, description:, owner:, starred: false)
  end

  describe "associations" do
    it "belongs to a GithubUser" do
      expect(described_class.all.map(&:owner)).to all eq owner
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(repository_one).to be_persisted

      test_wrong_record(github_id:, full_name:, name:, description:)
      test_wrong_record(github_id:, full_name:, name:, owner:)
      test_wrong_record(github_id:, full_name:, description:, owner:)
      test_wrong_record(github_id:, name:, description:, owner:)
      test_wrong_record(full_name:, name:, description:, owner:)
    end

    it "validates the numericality of github_id" do
      expect(repository_two).to be_persisted

      test_wrong_record(github_id: -1, full_name:, name:, description:, owner:)
      test_wrong_record(github_id: "a", full_name:, name:, description:, owner:)
    end

    it "validates the booleanility of starred" do
      expect(repository_one).to be_starred
      expect(repository_two).not_to be_starred

      test_wrong_record(github_id: -1, full_name:, name:, description:, owner:, starred: "true")
    end
  end

  private

  def test_wrong_record(params)
    record = GithubRepository.create(params)
    expect(record).not_to be_persisted
  end
end
