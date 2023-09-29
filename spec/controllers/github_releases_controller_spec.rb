require "rails_helper"

RSpec.describe GithubReleasesController, type: :request do
  before do
    GithubUser.destroy_all
    GithubRepository.destroy_all
    GithubRelease.destroy_all
  end

  let!(:owner) do
    GithubUser.create!(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository) do
    GithubRepository.create!(gid: 1, full_name: "wJoenn/wJoenn", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release) do
    GithubRelease.create!(
      gid: 1,
      name: "wJoenn v1.0.0",
      tag_name: "v1.0.0",
      html_url: "https://www.github.com",
      release_date: Time.current,
      repository:,
      author: owner
    )
  end

  let!(:reaction) { GithubReaction.create!(gid: 1, github_user_id: 75_388_869, content: "+1", release:) }

  describe "GET /index" do
    before do
      get "/github_releases"
    end

    it "responds with a status of 200" do
      expect(response).to have_http_status :ok
    end

    it "returns a JSON object" do
      expect(response.body).to be_a String
      expect(response.parsed_body).to have_key "releases"
    end

    it "returns an array of releases" do
      expect(response.parsed_body["releases"]).to eq [{
        "id" => release.gid,
        "name" => release.name,
        "tag_name" => release.tag_name,
        "body" => "",
        "html_url" => "https://www.github.com",
        "created_at" => release.release_date.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
        "read" => false,
        "reactions" => [{
          "id" => reaction.id,
          "user_id" => 75_388_869,
          "content" => "+1"
        }],
        "author" => {
          "id" => owner.gid,
          "login" => owner.login,
          "type" => owner.gh_type,
          "avatar_url" => owner.avatar_url,
          "html_url" => owner.html_url,
          "name" => nil,
          "bio" => nil,
          "location" => nil
        },
        "repository" => {
          "id" => repository.gid,
          "full_name" => repository.full_name,
          "name" => repository.name,
          "description" => repository.description,
          "language" => nil,
          "starred" => true,
          "owner" => {
            "id" => owner.gid,
            "login" => owner.login,
            "type" => owner.gh_type,
            "avatar_url" => owner.avatar_url,
            "html_url" => owner.html_url,
            "name" => nil,
            "bio" => nil,
            "location" => nil
          }
        }
      }]
    end
  end
end
