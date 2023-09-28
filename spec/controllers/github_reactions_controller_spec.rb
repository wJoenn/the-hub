require "rails_helper"

RSpec.describe GithubReactionsController, type: :request do
  let!(:owner) do
    GithubUser.create!(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository) do
    GithubRepository.create!(gid: 1, full_name: "wJoenn/TheHub", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release) do
    GithubRelease.create!(
      gid: 122_695_278,
      name: "wJoenn v1.0.0",
      tag_name: "v1.0.0",
      release_date: Time.current,
      repository:,
      author: owner
    )
  end

  let!(:content) { "eyes" }

  describe "GET /create" do
    before do
      post "/github_repositories/#{repository.gid}/github_releases/#{release.gid}/github_reactions",
        params: {
          github_reaction: { content: }
        }
    end

    it "creates a new GithubReaction" do
      expect(GithubReaction.count).to eq 1
    end

    it "returns a http status of 201" do
      expect(response).to have_http_status :created
    end

    it "returns a http status of 422" do
      post "/github_repositories/#{repository.gid}/github_releases/#{release.gid}/github_reactions",
        params: {
          github_reaction: { content: "++1" }
        }

      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe "GET /destroy" do
    let!(:reaction) { GithubReaction.create!(gid: 1, github_user_id: 1, content: "+1", release:) }

    before do
      uri = "/github_repositories/#{repository.gid}/github_releases/#{release.gid}/github_reactions/#{reaction.id}"
      delete uri
    end

    it "destroys a GithubReaction" do
      expect(GithubReaction.where(id: reaction.id)).to be_empty
      expect(response).to have_http_status :ok
    end
  end
end
