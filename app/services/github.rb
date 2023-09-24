require "octokit"

class Github
  def initialize(args = {})
    @client = Octokit::Client.new(access_token: Rails.application.credentials.github_token)
    @starred_limit = args[:starred_limit] || 30
    @release_limit = args[:release_limit] || 30
  end

  def md_to_html(markdown)
    return "" unless markdown

    @client.markdown(markdown)
  end

  def releases(repository)
    @client.per_page = @release_limit
    @client.releases(repository.full_name)
  end

  def starred_repositories
    @client.per_page = @starred_limit
    @client.starred(@client.user.login)
  end
end
