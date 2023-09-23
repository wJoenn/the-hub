require "rails_helper"

RSpec.describe GithubUser do
  let!(:github_id) { 1 }
  let!(:login) { "wJoenn" }
  let!(:avatar_url) { "wJoenn_avatar" }
  let!(:html_url) { "wJoenn_html" }
  let!(:user_one) { described_class.create(github_id:, login:, avatar_url:, html_url:) }
  let!(:user_two) { described_class.create(github_id: "1", login:, avatar_url:, html_url:) }

  describe "associations" do
    it "has many GithubRepository" do
      repository = GithubRepository.create(
        github_id: 1,
        full_name: "wJoenn/wJoenn",
        name: "wJoenn",
        description: "A repo",
        owner: user_one
      )

      expect(user_one.repositories).to contain_exactly repository
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(user_one).to be_persisted

      test_wrong_record(github_id:, login:, avatar_url:)
      test_wrong_record(github_id:, login:, html_url:)
      test_wrong_record(github_id:, avatar_url:, html_url:)
      test_wrong_record(login:, avatar_url:, html_url:)
    end

    it "validates the numericality of github_id" do
      expect(user_two).to be_persisted

      test_wrong_record(github_id: -1, login:, avatar_url:, html_url:)
      test_wrong_record(github_id: "a", login:, avatar_url:, html_url:)
    end
  end

  private

  def test_wrong_record(params)
    record = GithubUser.create(params)
    expect(record).not_to be_persisted
  end
end
