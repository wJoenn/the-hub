module Github
  class GetReleasesJob < Github::ApplicationJob
    def perform(args = {})
      @github = Github::Api.new(args)
      @github.starred_repositories.each { |starred_repository| update_repository(starred_repository) }
    end

    private

    def find_or_create_release(repository, release)
      github_release = Github::Release.find_or_initialize_by(gid: release.id)
      unless github_release.persisted?
        github_release.update!(
          name: release.name.presence || release.tag_name,
          tag_name: release.tag_name,
          body: @github.md_to_html(release.body),
          html_url: release.html_url,
          released_at: release.created_at,
          repository:,
          author: find_or_create_user(@github.user(release.author.login))
        )
      end

      github_release
    end

    def update_release(repository, release)
      github_release = find_or_create_release(repository, release)

      @github.reactions(repository, github_release).each do |reaction|
        find_or_create_reaction(github_release, reaction)
      end
    end

    def update_repository(repository)
      github_repository = find_or_create_repository(repository)
      @github.releases(github_repository).each { |release| update_release(github_repository, release) }
    end
  end
end
