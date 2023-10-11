require "rails_helper"

RSpec.describe Github::ReleasesController, type: :request do
  let!(:reaction) { create(:github_reaction, :with_release) }
  let!(:release) { reaction.reactable }
  let!(:author) { release.author }
  let!(:repository) { release.repository }
  let!(:owner) { repository.owner }

  describe "GET /index" do
    before do
      get "/github/releases"
    end

    it "responds with a status of 200" do
      expect(response).to have_http_status :ok
    end

    it "returns a JSON object" do
      expect(response.body).to be_a String
      expect(response.parsed_body).to have_key "releases"
    end

    it "returns an array of releases" do
      expect(response.parsed_body["releases"]).to contain_exactly({
        "id" => release.gid,
        "name" => release.name,
        "tag_name" => release.tag_name,
        "body" => release.body,
        "html_url" => release.html_url,
        "released_at" => release.released_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
        "read" => release.read?,
        "feed_type" => "GithubRelease",
        "reactions" => [{
          "id" => reaction.id,
          "user_id" => reaction.github_user_id,
          "content" => reaction.content,
          "reactable_type" => reaction.reactable_type
        }],
        "author" => {
          "id" => author.gid,
          "login" => author.login,
          "type" => author.gh_type,
          "avatar_url" => author.avatar_url,
          "html_url" => author.html_url,
          "name" => author.name,
          "bio" => author.bio,
          "location" => author.location
        },
        "repository" => {
          "id" => repository.gid,
          "full_name" => repository.full_name,
          "name" => repository.name,
          "description" => repository.description,
          "language" => repository.language,
          "starred" => repository.starred?,
          "stargazers_count" => repository.stargazers_count,
          "forks_count" => repository.forks_count,
          "pushed_at" => repository.pushed_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
          "html_url" => repository.html_url,
          "owner" => {
            "id" => owner.gid,
            "login" => owner.login,
            "type" => owner.gh_type,
            "avatar_url" => owner.avatar_url,
            "html_url" => owner.html_url,
            "name" => owner.name,
            "bio" => owner.bio,
            "location" => owner.location
          }
        }
      })
    end
  end
end
