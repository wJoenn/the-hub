require "rails_helper"

RSpec.describe IsGithubModel, type: :concern do
  let!(:login) { "wJoenn" }
  let!(:gh_type) { "User" }
  let!(:avatar_url) { "wJoenn/avatar" }
  let!(:html_url) { "wJoenn/html" }
  let!(:user) { create(:github_user) }

  describe "validations" do
    it "validates the presence of gid" do
      test_wrong_record(login:, gh_type:, avatar_url:, html_url:)
    end

    it "validates the numericality of gid" do
      test_wrong_record(gid: -1, login:, gh_type:, avatar_url:, html_url:)
      test_wrong_record(gid: "a", login:, gh_type:, avatar_url:, html_url:)
    end
  end

  describe "by_gid" do
    it "finds a github model by its gid" do
      expect(GithubUser.by_gid(user.gid)).to eq user
    end
  end

  private

  def test_wrong_record(params)
    record = GithubUser.create(params)
    expect(record).not_to be_persisted
  end
end
