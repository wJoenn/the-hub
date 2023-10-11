require "rails_helper"

RSpec.describe Github::CommentsController, type: :request do
  let!(:issue_reaction) { create(:github_reaction, :with_issue) }
  let!(:issue) { issue_reaction.reactable }
  let!(:comment_reaction) { create(:github_reaction, reactable: create(:github_comment, issue:)) }
  let!(:comment) { comment_reaction.reactable }
  let!(:comment_author) { comment.author }
  let!(:issue_author) { issue.author }
  let!(:repository) { issue.repository }
  let!(:owner) { repository.owner }

  describe "GET /index" do
    before do
      get "/github/comments"
    end

    it "responds with a status of 200" do
      expect(response).to have_http_status :ok
    end

    it "returns a JSON object" do
      expect(response.body).to be_a String
      expect(response.parsed_body).to have_key "comments"
    end

    it "returns an array of comments" do
      expect(response.parsed_body["comments"]).to contain_exactly({
        "id" => comment.gid,
        "body" => comment.body,
        "html_url" => comment.html_url,
        "released_at" => comment.released_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
        "read" => comment.read?,
        "feed_type" => "GithubComment",
        "reactions" => [{
          "id" => comment_reaction.id,
          "user_id" => comment_reaction.github_user_id,
          "content" => comment_reaction.content,
          "reactable_type" => comment_reaction.reactable_type
        }],
        "author" => {
          "id" => comment_author.gid,
          "login" => comment_author.login,
          "type" => comment_author.gh_type,
          "avatar_url" => comment_author.avatar_url,
          "html_url" => comment_author.html_url,
          "name" => comment_author.name,
          "bio" => comment_author.bio,
          "location" => comment_author.location
        },
        "issue" => {
          "id" => issue.gid,
          "body" => issue.body,
          "html_url" => issue.html_url,
          "state" => issue.state,
          "title" => issue.title,
          "issue_type" => issue.gh_type,
          "number" => issue.number,
          "feed_type" => "GithubIssue",
          "released_at" => issue.released_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
          "reactions" => [{
            "id" => issue_reaction.id,
            "user_id" => issue_reaction.github_user_id,
            "content" => issue_reaction.content,
            "reactable_type" => issue_reaction.reactable_type
          }],
          "author" => {
            "id" => issue_author.gid,
            "login" => issue_author.login,
            "type" => issue_author.gh_type,
            "avatar_url" => issue_author.avatar_url,
            "html_url" => issue_author.html_url,
            "name" => issue_author.name,
            "bio" => issue_author.bio,
            "location" => issue_author.location
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
        }
      })
    end
  end
end
