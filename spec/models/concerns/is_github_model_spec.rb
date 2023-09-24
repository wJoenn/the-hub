require "rails_helper"

RSpec.describe IsGithubModel, type: :concern do
  let!(:user) { GithubUser.create(gid: 1, login: "wJoenn", avatar_url: "wJoenn_avatar", html_url: "wJoenn_html") }

  describe "by_gid" do
    it "finds a github model by its gid" do
      expect(GithubUser.by_gid(user.gid)).to eq user
    end
  end
end
