module Github
  class GetCommentsJob < Github::ApplicationJob
    def perform(args = {})
      @github = Github::Api.new(args)
      @github.notifications.each do |notification|
        github_repository = find_or_create_repository(@github.repository(notification.repository.full_name))

        issue_number = issue_number_from_url(notification.subject.url)
        issue = @github.issue(github_repository, issue_number)
        update_issue(github_repository, issue)
      end
    end

    private

    def find_or_create_comment(issue, comment)
      github_comment = Github::Comment.find_or_initialize_by(gid: comment.id)
      unless github_comment.persisted?
        github_comment.update!(
          gid: comment.id,
          html_url: comment.html_url,
          body: @github.md_to_html(comment.body),
          released_at: comment.created_at,
          author: find_or_create_user(@github.user(comment.user.login)),
          issue:
        )
      end

      github_comment
    end

    def find_or_create_issue(repository, issue)
      github_issue = Github::Issue.find_or_initialize_by(gid: issue.id)
      github_issue.update!(
        gid: issue.id,
        html_url: issue.html_url,
        body: @github.md_to_html(issue.body),
        state: issue.state,
        title: issue.title,
        gh_type: issue_type(issue.html_url),
        number: issue.number,
        released_at: issue.created_at,
        author: find_or_create_user(@github.user(issue.user.login)),
        repository:
      )

      github_issue
    end

    def issue_number_from_url(url)
      url.match(/\/(\d+)$/)[1].to_i
    end

    def issue_type(url)
      url.match?(/\/issues\/\d+$/) ? "Issue" : "PullRequest"
    end

    def update_comment(issue, comment)
      github_comment = find_or_create_comment(issue, comment)

      reactions_path = "/repos/#{issue.repository.full_name}/issues/comments/#{github_comment.gid}/reactions"
      @github.reactions(reactions_path).each do |reaction|
        find_or_create_reaction(github_comment, reaction)
      end
    end

    def update_issue(repository, issue)
      github_issue = find_or_create_issue(repository, issue)

      reactions_path = "/repos/#{repository.full_name}/issues/#{github_issue.number}/reactions"
      @github.reactions(reactions_path).each do |reaction|
        find_or_create_reaction(github_issue, reaction)
      end

      @github.issue_comments(repository, github_issue).each { |comment| update_comment(github_issue, comment) }
    end
  end
end
