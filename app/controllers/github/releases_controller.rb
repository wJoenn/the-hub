module Github
  class ReleasesController < ApplicationController
    def index
      render json: { releases: serialized_releases }, status: :ok
    end

    private

    def queried_releases
      Github::Release.includes(:author, repository: :owner).order(release_date: :desc).limit(30)
    end

    def serialized_reactions(release)
      release.reactions.map do |reaction|
        {
          id: reaction.id,
          user_id: reaction.github_user_id,
          content: reaction.content
        }
      end
    end

    def serialized_releases
      queried_releases.map do |release|
        {
          id: release.gid,
          name: release.name,
          tag_name: release.tag_name,
          body: release.body,
          html_url: release.html_url,
          read: release.read?,
          created_at: release.release_date,
          reactions: serialized_reactions(release),
          repository: serialized_repository(release.repository),
          author: serialized_user(release.author)
        }
      end
    end

    def serialized_repository(repository)
      {
        id: repository.gid,
        full_name: repository.full_name,
        name: repository.name,
        description: repository.description,
        language: repository.language,
        starred: repository.starred?,
        stargazers_count: repository.stargazers_count,
        forks_count: repository.forks_count,
        pushed_at: repository.pushed_at,
        html_url: repository.html_url,
        owner: serialized_user(repository.owner)
      }
    end

    def serialized_user(user)
      {
        id: user.gid,
        login: user.login,
        type: user.gh_type,
        avatar_url: user.avatar_url,
        html_url: user.html_url,
        name: user.name,
        bio: user.bio,
        location: user.location
      }
    end
  end
end
