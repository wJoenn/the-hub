require "rails_helper"

RSpec.describe GithubReleasesController, type: :request do
  before do
    GithubUser.destroy_all
    GithubRepository.destroy_all
    GithubRelease.destroy_all
  end

  let!(:gid) { 1 }
  let!(:name) { "wJoenn v1.0.0" }
  let!(:tag_name) { "v1.0.0" }
  let!(:release_date) { Time.current }
  let!(:owner) do
    GithubUser.create(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository) do
    GithubRepository.create(gid: 1, full_name: "wJoenn/wJoenn", name: "wJoenn", description: "A repo", owner:)
  end

  describe "GET /index" do
    before do
      GithubRelease.create(gid:, name:, tag_name:, release_date:, repository:, author: owner)
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
        "id" => gid,
        "name" => name,
        "tag_name" => tag_name,
        "body" => "",
        "created_at" => release_date.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
        "read" => false,
        "reactions" => {
          "+1" => 0,
          "-1" => 0,
          "confused" => 0,
          "eyes" => 0,
          "heart" => 0,
          "hooray" => 0,
          "laugh" => 0,
          "rocket" => 0
        },
        "author" => {
          "id" => owner.gid,
          "login" => owner.login,
          "type" => owner.gh_type,
          "avatar_url" => owner.avatar_url,
          "html_url" => owner.html_url
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
            "html_url" => owner.html_url
          }
        }
      }]
    end
  end
end
