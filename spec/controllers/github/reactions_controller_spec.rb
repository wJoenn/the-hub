require "rails_helper"

RSpec.describe Github::ReactionsController, type: :request do
  let!(:comment) { create(:github_comment) }
  let!(:issue) { comment.issue }
  let!(:release) { create(:github_release) }
  let!(:repository) { create(:github_repository) }
  let!(:params) { { reaction: { content: "eyes" } } }

  describe "GET /create" do
    it "creates a new reaction for a Github::Comment" do
      post("/github/repositories/#{repository.gid}/comments/#{comment.gid}/reactions", params:)
      expect(comment.reactions.count).to eq 1
    end

    it "creates a new reaction for a Github::Issue" do
      post("/github/repositories/#{repository.gid}/issues/#{issue.gid}/reactions", params:)
      expect(issue.reactions.count).to eq 1
    end

    it "creates a new reaction for a Github::Release" do
      post("/github/repositories/#{repository.gid}/releases/#{release.gid}/reactions", params:)
      expect(release.reactions.count).to eq 1
    end

    it "creates a new reaction by me" do
      post("/github/repositories/#{repository.gid}/releases/#{release.gid}/reactions", params:)
      expect(release.reactions.first.github_user_id).to eq Rails.application.credentials.github_user_id
    end

    it "returns a http status of 201" do
      post("/github/repositories/#{repository.gid}/comments/#{comment.gid}/reactions", params:)
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
    let!(:comment_reaction) { create(:github_reaction, :with_comment) }
    let!(:issue_reaction) { create(:github_reaction, :with_issue) }
    let!(:release_reaction) { create(:github_reaction, :with_release) }

    it "destroys a Github::comment reaction" do
      delete "/github/repositories/#{repository.gid}/comments/#{comment.gid}/reactions/#{comment_reaction.id}"
      expect(Github::Reaction.where(id: comment_reaction.id)).to be_empty
      expect(response).to have_http_status :ok
    end

    it "destroys a Github::Issue reaction" do
      delete "/github/repositories/#{repository.gid}/issues/#{issue.gid}/reactions/#{issue_reaction.id}"
      expect(Github::Reaction.where(id: issue_reaction.id)).to be_empty
      expect(response).to have_http_status :ok
    end

    it "destroys a Github::Release reaction" do
      delete "/github/repositories/#{repository.gid}/releases/#{release.gid}/reactions/#{release_reaction.id}"
      expect(Github::Reaction.where(id: release_reaction.id)).to be_empty
      expect(response).to have_http_status :ok
    end
  end
end
