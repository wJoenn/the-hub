require "octokit"
require "net/http"

class Github
  def initialize(args = {})
    @client = Octokit::Client.new(access_token: Rails.application.credentials.github_token)
    @starred_limit = args[:starred_limit] || 30
    @release_limit = args[:release_limit] || 30
    @reaction_limit = args[:reaction_limit] || 100
  end

  def md_to_html(markdown)
    return "" unless markdown

    @client.markdown(markdown)
  end

  def reactions(repository, release, page = 1)
    query = "?per_page=#{@reaction_limit}&page=#{page}"
    uri = URI("https://api.github.com/repos/#{repository.full_name}/releases/#{release.gid}/reactions#{query}")

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
      https.request(get_request(uri))
    end

    reactions = JSON.parse(response.body)
    reactions.concat(reactions(repository, release, page + 1)) if reactions.length == 100 * page
    reactions
  end

  def releases(repository)
    @client.per_page = @release_limit
    @client.releases(repository.full_name)
  end

  def starred_repositories
    @client.per_page = @starred_limit
    @client.starred(@client.user.login)
  end

  private

  def get_request(uri)
    request = Net::HTTP::Get.new(uri)

    request["Accept"] = "application/vnd.github+json"
    request["Authorization"] = "Bearer #{Rails.application.credentials.github_token}"
    request["X-GitHub-Api-Version"] = "2022-11-28"

    request
  end
end
