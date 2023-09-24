require "rails_helper"

RSpec.describe GithubRelease do
  let!(:gid) { 1 }
  let!(:name) { "wJoenn v1.0.0" }
  let!(:tag_name) { "v1.0.0" }
  let!(:release_date) { Time.current }
  let!(:owner) { GithubUser.create(gid: 1, login: "wJoenn", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html") }

  let!(:repository) do
    GithubRepository.create(gid: 1, full_name: "wJoenn/wJoenn", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release_one) { described_class.create(gid:, name:, tag_name:, release_date:, repository:) }
  let!(:release_two) { described_class.create(gid: "1", name:, tag_name:, release_date:, repository:, read: true) }

  describe "associations" do
    it "belongs to a GithubRepository" do
      expect(described_class.all.map(&:repository)).to all eq repository
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(release_one).to be_persisted

      test_wrong_record(gid:, name:, tag_name:, release_date:)
      test_wrong_record(gid:, name:, tag_name:, repository:)
      test_wrong_record(gid:, name:, release_date:, repository:)
      test_wrong_record(gid:, tag_name:, release_date:, repository:)
      test_wrong_record(name:, tag_name:, release_date:, repository:)
    end

    it "validates the numericality of gid" do
      expect(release_two).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:)
    end

    it "validates the numericality of reactions_plus_one" do
      release_one.update(reactions_plus_one: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_plus_one: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_plus_one: "a")
    end

    it "validates the numericality of reactions_minus_one" do
      release_one.update(reactions_minus_one: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_minus_one: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_minus_one: "a")
    end

    it "validates the numericality of reactions_confused" do
      release_one.update(reactions_confused: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_confused: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_confused: "a")
    end

    it "validates the numericality of reactions_eyes" do
      release_one.update(reactions_eyes: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_eyes: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_eyes: "a")
    end

    it "validates the numericality of reactions_heart" do
      release_one.update(reactions_heart: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_heart: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_heart: "a")
    end

    it "validates the numericality of reactions_hooray" do
      release_one.update(reactions_hooray: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_hooray: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_hooray: "a")
    end

    it "validates the numericality of reactions_laugh" do
      release_one.update(reactions_laugh: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_laugh: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_laugh: "a")
    end

    it "validates the numericality of reactions_rocket" do
      release_one.update(reactions_rocket: 1)
      expect(release_one).to be_persisted

      test_wrong_record(gid: -1, name:, tag_name:, release_date:, repository:, reactions_rocket: -1)
      test_wrong_record(gid: "a", name:, tag_name:, release_date:, repository:, reactions_rocket: "a")
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
