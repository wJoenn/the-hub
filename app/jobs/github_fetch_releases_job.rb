class GithubFetchReleasesJob < ApplicationJob
  def perform(args = {})
    @github = Github.new(args)
    @github.starred_repositories.each { |starred_repository| update_or_create_repository(starred_repository) }
  end

  private

  def find_or_create_user(user)
    github_user = GithubUser.find_or_initialize_by(gid: user.id)
    github_user.update!(login: user.login, avatar_url: user.avatar_url, html_url: user.html_url)
    github_user
  end

  def update_or_create_release(release, repository)
    github_release = GithubRelease.find_or_initialize_by(gid: release.id)

    unless github_release.persisted?
      github_release.update!(
        name: release.name.presence || release.tag_name,
        tag_name: release.tag_name,
        body: @github.md_to_html(release.body),
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

    @github.releases(repository).each { |release| update_or_create_release(release, repository) }
  end
end
