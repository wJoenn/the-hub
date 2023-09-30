require "rails_helper"

RSpec.describe GithubRepository do
  let!(:gid) { 1 }
  let!(:full_name) { "wJoenn/wJoenn" }
  let!(:name) { "wJoenn" }
  let!(:description) { "A repo" }

  let!(:owner) { create(:github_user) }
  let!(:repository_one) { create(:github_repository) }
  let!(:repository_two) { create(:github_repository, starred: false) }


  describe "associations" do
    it "has many GithubRelease" do
      release = create(:github_release)
      expect(repository_one.releases).to all be_a GithubRelease
    end

    it "belongs to a GithubUser" do
      expect(repository_one.owner).to be_a GithubUser
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
