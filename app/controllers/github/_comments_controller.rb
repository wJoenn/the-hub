module Github
  class CommentsController < ApplicationController
    def index
      render json: { comments: serialized_comments(queried_comments) }, status: :ok
    end

    private

    def queried_comments
      Github::Comment
        .includes(:author, issue: [:author, { repository: :owner }])
        .order(released_at: :desc)
        .limit(30)
    end

    def serialized_comments(comments)
      comments.map do |comment|
        {
          id: comment.gid,
          body: comment.body,
          html_url: comment.html_url,
          read: comment.read?,
          feed_type: comment.feed_type,
          released_at: comment.released_at,
          reactions: serialized_reactions(comment),
          issue: serialized_issue(comment.issue),
          author: serialized_user(comment.author)
        }
      end
    end

    def serialized_issue(issue)
      {
        id: issue.gid,
        body: issue.body,
        html_url: issue.html_url,
        state: issue.state,
        title: issue.title,
        issue_type: issue.gh_type,
        number: issue.number,
        feed_type: issue.feed_type,
        released_at: issue.released_at,
        reactions: serialized_reactions(issue),
        author: serialized_user(issue.author),
        repository: serialized_repository(issue.repository)
      }
    end
  end
end
