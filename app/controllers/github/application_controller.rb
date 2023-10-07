module Github
  class ApplicationController < ApplicationController
    private

    def serialized_reactions(release)
      release.reactions.map do |reaction|
        {
          id: reaction.id,
          user_id: reaction.github_user_id,
          content: reaction.content,
          reactable_type: reaction.reactable_type
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
