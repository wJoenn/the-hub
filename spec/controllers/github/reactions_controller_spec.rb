require "rails_helper"

RSpec.describe Github::ReactionsController, type: :request do
  let!(:repository) { create(:github_repository) }
  let!(:release) { create(:github_release) }
  let!(:content) { "eyes" }

  describe "GET /create" do
    before do
      post "/github/repositories/#{repository.gid}/releases/#{release.gid}/reactions",
        params: {
          reaction: { content: }
        }
    end

    it "creates a new GithubReaction" do
      expect(Github::Reaction.count).to eq 1
    end

    it "returns a http status of 201" do
      expect(response).to have_http_status :created
    end

    it "returns a http status of 422" do
      post "/github/repositories/#{repository.gid}/releases/#{release.gid}/reactions",
        params: {
          reaction: { content: "++1" }
        }

      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe "GET /destroy" do
    let!(:reaction) { Github::Reaction.create!(gid: 1, github_user_id: 1, content: "+1", release:) }

    before do
      uri = "/github/repositories/#{repository.gid}/releases/#{release.gid}/reactions/#{reaction.id}"
      delete uri
    end

    it "destroys a GithubReaction" do
      expect(Github::Reaction.where(id: reaction.id)).to be_empty
      expect(response).to have_http_status :ok
    end
  end
end
