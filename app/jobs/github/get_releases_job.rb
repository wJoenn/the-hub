module Github
  class GetReleasesJob < ApplicationJob
    def perform(args = {})
      @github = Github::Api.new(args)
      @github.starred_repositories.each { |starred_repository| update_or_create_repository(starred_repository) }
    end

    private

    def find_or_create_reaction(release, reaction)
      github_reaction = Github::Reaction.find_or_initialize_by(gid: reaction["id"])
      github_reaction.update!(github_user_id: reaction["user"]["id"], content: reaction["content"], release:)
      github_reaction
    end

    def find_or_create_user(user)
      # Remove automatic call once every users have been updated
      user = @github.user(user.login)
      github_user = Github::User.find_or_initialize_by(gid: user.id)

      github_user.update!(
        login: user.login,
        gh_type: user.type,
        avatar_url: user.avatar_url,
        html_url: user.html_url,
        name: user.name,
        bio: user.bio,
        location: user.location
      )

      github_user
    end

    def update_or_create_release(repository, release)
      github_release = Github::Release.find_or_initialize_by(gid: release.id)

      unless github_release.persisted?
        github_release.update!(
          name: release.name.presence || release.tag_name,
          tag_name: release.tag_name,
          body: @github.md_to_html(release.body),
          html_url: release.html_url,
          released_at: release.created_at,
          repository:,
          author: find_or_create_user(release.author)
        )
      end

      @github.reactions(repository, github_release).each do |reaction|
        find_or_create_reaction(github_release, reaction)
      end
    end

    def update_or_create_repository(starred_repository)
      repository = Github::Repository.find_or_initialize_by(gid: starred_repository.id)
      repository.update!(
        full_name: starred_repository.full_name,
        name: starred_repository.name,
        description: starred_repository.description,
        language: starred_repository.language,
        stargazers_count: starred_repository.stargazers_count,
        forks_count: starred_repository.forks_count,
        html_url: starred_repository.html_url,
        pushed_at: starred_repository.pushed_at,
        owner: find_or_create_user(starred_repository.owner)
      )

      @github.releases(repository).each { |release| update_or_create_release(repository, release) }
    end
  end
end
