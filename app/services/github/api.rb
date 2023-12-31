require "octokit"

module Github
  class Api
    def initialize(args = {})
      @client = Octokit::Client.new(access_token: Rails.application.credentials.github_token)
      @starred_limit = args[:starred_limit] || 1
      @release_limit = args[:release_limit] || 1
      @notification_limit = args[:notification_limit] || 1
      @reaction_limit = args[:reaction_limit] || 1
      @issue_comment_limit = args[:issue_comment_limit] || 1

      @base_url = "https://api.github.com"
      @headers = {
        "Accept" => "application/vnd.github+json",
        "Authorization" => "Bearer #{Rails.application.credentials.github_token}",
        "X-GitHub-Api-Version" => "2022-11-28"
      }
    end

    def create_reaction(repository, reactable_path, reaction)
      uri = URI("#{@base_url}/repos/#{repository.full_name}/#{reactable_path}/reactions")
      body = { content: reaction.content }.to_json

      HTTParty.post(uri, body:, headers: @headers)
    end

    def delete_reaction(repository, reactable_path, reaction_gid)
      uri = URI("#{@base_url}/repos/#{repository.full_name}/#{reactable_path}/reactions/#{reaction_gid}")

      HTTParty.delete(uri, headers: @headers)
    end

    def issue(repository, issue_number)
      @client.issue(repository.full_name, issue_number)
    end

    def issue_comments(repository, issue)
      @client.per_page = @issue_comment_limit
      @client.issue_comments(repository.full_name, issue.number)
    end

    def md_to_html(markdown)
      return "" unless markdown

      @client.markdown(markdown)
    end

    def notifications
      @client.per_page = @notification_limit
      @client.notifications(all: true)
    end

    def reactions(path, page = 1)
      query = "?per_page=#{@reaction_limit}&page=#{page}"
      uri = URI("#{@base_url}#{path}#{query}")

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
