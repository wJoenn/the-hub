require "octokit"

module Github
  class Api
    def initialize(args = {})
      @client = Octokit::Client.new(access_token: Rails.application.credentials.github_token)
      @starred_limit = args[:starred_limit] || 1
      @release_limit = args[:release_limit] || 1
      @notification_limit = args[:notification_limit] || 1
      @reaction_limit = args[:reaction_limit] || 1
      @issue_comment_limit = args[:issue_comment] || 1

      @base_url = "https://api.github.com"
      @headers = {
        "Accept" => "application/vnd.github+json",
        "Authorization" => "Bearer #{Rails.application.credentials.github_token}",
        "X-GitHub-Api-Version" => "2022-11-28"
      }
    end

    def create_release_reaction(repository, release, reaction)
      uri = URI("#{@base_url}/repos/#{repository.full_name}/releases/#{release.gid}/reactions")
      body = { content: reaction.content }.to_json

      HTTParty.post(uri, body:, headers: @headers)
    end

    def delete_release_reaction(repository, release, reaction_gid)
      uri = URI("#{@base_url}/repos/#{repository.full_name}/releases/#{release.gid}/reactions/#{reaction_gid}")

      HTTParty.delete(uri, headers: @headers)
    end

    def issue(repository, issue_number)
      @client.issue(repository.full_name, issue_number)
    end

    def issue_comments(repository, issue)
      @client.per_page = @issue_comment_limit
      @client.issue_comments(repository.full_name, issue.number)
    end

    def issue_comment_reactions(repository, comment, page = 1)
      query = "?per_page=#{@reaction_limit}&page=#{page}"
      uri = URI("#{@base_url}/repos/#{repository.full_name}/issues/comments/#{comment.gid}/reactions#{query}")

      response = HTTParty.get(uri, headers: @headers)

      reactions = JSON.parse(response.body)
      reactions.concat(reactions(repository, release, page + 1)) if reactions.length == 100 * page
      reactions
    end

    def md_to_html(markdown)
      return "" unless markdown

      @client.markdown(markdown)
    end

    def notifications
      @client.per_page = @notification_limit
      @client.notifications(all: true)
    end

    def release_reactions(repository, release, page = 1)
      query = "?per_page=#{@reaction_limit}&page=#{page}"
      uri = URI("#{@base_url}/repos/#{repository.full_name}/releases/#{release.gid}/reactions#{query}")

      response = HTTParty.get(uri, headers: @headers)

      reactions = JSON.parse(response.body)
      reactions.concat(reactions(repository, release, page + 1)) if reactions.length == 100 * page
      reactions
    end

    def releases(repository)
      @client.per_page = @release_limit
      @client.releases(repository.full_name)
    end

    def repository(full_name)
      @client.repository(full_name)
    end

    def starred_repositories
      @client.per_page = @starred_limit
      @client.starred(@client.user.login)
    end

    def user(login)
      @client.user(login)
    end
  end
end

# [{
#   :id=>"5130659532",
#   :unread=>false,
#   :reason=>"author",
#   :updated_at=>2023-10-03 21:32:03 UTC,
#   :last_read_at=>2023-10-03 21:32:08 UTC,
#   :subject=> {
#     :title=> "Issue#177 Integrate a mapping between batch numbers and campuses from scrapped data",
#     :url=>"https://api.github.com/repos/pil0u/lewagon-aoc/pulls/212",
#     :latest_comment_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/issues/comments/1745758534",
#     :type=>"PullRequest"
#   },
#   :repository=> {
#     :id=>389079238,
#     :node_id=>"MDEwOlJlcG9zaXRvcnkzODkwNzkyMzg=",
#     :name=>"lewagon-aoc",
#     :full_name=>"pil0u/lewagon-aoc",
#     :private=>false,
#     :owner=> {
#       :login=>"pil0u",
#       :id=>8350914,
#       :node_id=>"MDQ6VXNlcjgzNTA5MTQ=",
#       :avatar_url=>"https://avatars.githubusercontent.com/u/8350914?v=4",
#       :gravatar_id=>"",
#       :url=>"https://api.github.com/users/pil0u",
#       :html_url=>"https://github.com/pil0u",
#       :followers_url=>"https://api.github.com/users/pil0u/followers",
#       :following_url=> "https://api.github.com/users/pil0u/following{/other_user}",
#       :gists_url=>"https://api.github.com/users/pil0u/gists{/gist_id}",
#       :starred_url=>"https://api.github.com/users/pil0u/starred{/owner}{/repo}",
#       :subscriptions_url=>"https://api.github.com/users/pil0u/subscriptions",
#       :organizations_url=>"https://api.github.com/users/pil0u/orgs",
#       :repos_url=>"https://api.github.com/users/pil0u/repos",
#       :events_url=>"https://api.github.com/users/pil0u/events{/privacy}",
#       :received_events_url=> "https://api.github.com/users/pil0u/received_events",
#       :type=>"User",
#       :site_admin=>false
#     },
#     :html_url=>"https://github.com/pil0u/lewagon-aoc",
#     :description=>"Advent of Code x Le Wagon",
#     :fork=>false,
#     :url=>"https://api.github.com/repos/pil0u/lewagon-aoc",
#     :forks_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/forks",
#     :keys_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/keys{/key_id}",
#     :collaborators_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/collaborators{/collaborator}",
#     :teams_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/teams",
#     :hooks_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/hooks",
#     :issue_events_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/issues/events{/number}",
#     :events_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/events",
#     :assignees_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/assignees{/user}",
#     :branches_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/branches{/branch}",
#     :tags_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/tags",
#     :blobs_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/git/blobs{/sha}",
#     :git_tags_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/git/tags{/sha}",
#     :git_refs_url=> "https://api.github.com/repos/pil0u/lewagon-aoc/git/refs{/sha}",
#     :trees_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/git/trees{/sha}",
#     :statuses_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/statuses/{sha}",
#     :languages_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/languages",
#     :stargazers_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/stargazers",
#     :contributors_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/contributors",
#     :subscribers_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/subscribers",
#     :subscription_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/subscription",
#     :commits_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/commits{/sha}",
#     :git_commits_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/git/commits{/sha}",
#     :comments_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/comments{/number}",
#     :issue_comment_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/issues/comments{/number}",
#     :contents_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/contents/{+path}",
#     :compare_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/compare/{base}...{head}",
#     :merges_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/merges",
#     :archive_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/{archive_format}{/ref}",
#     :downloads_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/downloads",
#     :issues_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/issues{/number}",
#     :pulls_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/pulls{/number}",
#     :milestones_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/milestones{/number}",
#     :notifications_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/notifications{?since,all,participating}",
#     :labels_url=>"https://api.github.com/repos/pil0u/lewagon-aoc/labels{/name}",
#     :releases_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/releases{/id}",
#     :deployments_url=>
#      "https://api.github.com/repos/pil0u/lewagon-aoc/deployments"},
#   :url=>"https://api.github.com/notifications/threads/5130659532",
#   :subscription_url=>
#    "https://api.github.com/notifications/threads/5130659532/subscription"}
#  ]
