require "rails_helper"

def test_correct_record(params)
  record = GithubUser.create(params)
  expect(record).to be_persisted
end

def test_wrong_record(params)
  record = GithubUser.create(params)
  expect(record).not_to be_persisted
end

RSpec.describe GithubUser do
  let!(:github_id) { 1 }
  let!(:login) { "wJoenn" }
  let!(:avatar_url) { "wJoenn_avatar" }
  let!(:html_url) { "wJoenn_html" }

  describe "validations" do
    it "validates the presence of all attributes" do
      test_correct_record(github_id:, login:, avatar_url:, html_url:)
      test_wrong_record(github_id:, login:, avatar_url:)
      test_wrong_record(github_id:, login:, html_url:)
      test_wrong_record(github_id:, avatar_url:, html_url:)
      test_wrong_record(login:, avatar_url:, html_url:)
    end

    it "validates the numericality of github_id" do
      test_correct_record(github_id: "1", login:, avatar_url:, html_url:)
      test_wrong_record(github_id: -1, login:, avatar_url:, html_url:)
      test_wrong_record(github_id: "a", login:, avatar_url:, html_url:)
    end
  end
end
