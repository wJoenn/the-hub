require "octokit"

class GithubOctokit
  def initialize(args = {})
    @client = Octokit::Client.new(access_token: Rails.application.credentials.github_token)
    @starred_limit = args[:starred_limit] || 30
    @release_limit = args[:release_limit] || 30
  end

  def fetch
    starred_repositories.each { |starred_repository| update_or_create_repository(starred_repository) }
  end

  private

  def find_or_create_user(user)
    github_user = GithubUser.find_or_initialize_by(gid: user.id)
    github_user.update!(login: user.login, avatar_url: user.avatar_url, html_url: user.html_url)
    github_user
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

  def update_or_create_release(release, repository)
    github_release = GithubRelease.find_or_initialize_by(gid: release.id)
    unless github_release.persisted?
      github_release.update!(
        name: release.name.presence || release.tag_name,
        tag_name: release.tag_name,
        body: md_to_html(release.body),
        release_date: release.created_at,
        repository:,
        author: find_or_create_user(release.author)
      )
    end

    return if release.reactions.nil?

    github_release.update!(
      reactions_plus_one: release.reactions[:"+1"],
      reactions_minus_one: release.reactions[:"-1"],
      reactions_confused: release.reactions.confused,
      reactions_eyes: release.reactions.eyes,
      reactions_heart: release.reactions.heart,
      reactions_hooray: release.reactions.hooray,
      reactions_laugh: release.reactions.laugh,
      reactions_rocket: release.reactions.rocket
    )
  end

  def update_or_create_repository(starred_repository)
    repository = GithubRepository.find_or_initialize_by(gid: starred_repository.id)
    repository.update!(
      full_name: starred_repository.full_name,
      name: starred_repository.name,
      description: starred_repository.name,
      owner: find_or_create_user(starred_repository.owner)
    )

    releases(repository).each { |release| update_or_create_release(release, repository) }
  end
end
