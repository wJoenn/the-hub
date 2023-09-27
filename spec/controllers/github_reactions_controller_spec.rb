require "rails_helper"

RSpec.describe GithubReactionsController, type: :request do
  let!(:owner) do
    GithubUser.create!(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository_one) do
    GithubRepository.create!(gid: 1, full_name: "wJoenn/TheHu", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:repository_two) do
    GithubRepository.create!(gid: 695661101, full_name: "wJoenn/TheHub", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release) do
    GithubRelease.create!(
      gid: 122695278,
      name: "wJoenn v1.0.0",
      tag_name: "v1.0.0",
      release_date: Time.current,
      repository: repository_two,
      author: owner
    )
  end

  let!(:content) { "eyes" }

  # let!(:reaction) { described_class.create(gid:, github_user_id:, content:, release:) }

  describe "GET /create" do
    before do
      post "/github_repositories/#{repository_two.gid}/github_releases/#{release.gid}/github_reactions",
      params: {
        reaction: { content: }
      }
    end

    it "creates a new GithubReaction" do
      expect(GithubReaction.count).to eq 1
    end

    it "returns a http status of 201" do
      expect(response).to have_http_status :created
    end

    it "returns a http status of 404" do
      post "/github_repositories/#{repository_one.gid}/github_releases/#{release.gid}/github_reactions", params: {
        reaction: { content: }
      }

      expect(response).to have_http_status :not_found
    end
  end

  describe "GET /destroy" do
    let!(:reaction) { Github.new.reactions(repository_two, release).first }

    context "when it exists" do
      before do
        GithubReaction.create!(gid: reaction["id"], github_user_id: 1, content: reaction["content"], release:)

        uri = "/github_repositories/#{repository_two.gid}/github_releases/#{release.gid}/github_reactions/#{reaction["id"]}"
        delete uri
      end

      it "destroys a GithubReaction" do
        expect(GithubReaction.exists?(gid: reaction["id"])).to be_falsy
        expect(response).to have_http_status :ok
      end
    end

    context "when it does exist" do
      it "returns a http status code of 404" do
        uri = "/github_repositories/#{repository_two.gid}/github_releases/#{release.gid}/github_reactions/105"
        delete uri

        expect(response).to have_http_status :not_found
      end
    end
  end
end
