module Github
  class ApplicationJob < ApplicationJob
    private

    def find_or_create_reaction(reactable, reaction)
      github_reaction = Github::Reaction.find_or_initialize_by(gid: reaction["id"])
      unless github_reaction.persisted?
        github_reaction.update!(github_user_id: reaction["user"]["id"], content: reaction["content"], reactable:)
      end

      github_reaction
    end

    def find_or_create_user(user)
      # Remove automatic call once every users have been updated
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

    def find_or_create_repository(repository)
      github_repository = Github::Repository.find_or_initialize_by(gid: repository.id)
      github_repository.update!(
        full_name: repository.full_name,
        name: repository.name,
        description: repository.description,
        language: repository.language,
        stargazers_count: repository.stargazers_count,
        forks_count: repository.forks_count,
        html_url: repository.html_url,
        pushed_at: repository.pushed_at,
        owner: find_or_create_user(@github.user(repository.owner.login))
      )

      github_repository
    end

    def reactable_path
      case @reactable.class.to_s
      when "Github::Comment" then "issues/comments/#{@reactable.gid}"
      when "Github::Issue" then "issues/#{@reactable.number}"
      when "Github::Release" then "releases/#{@reactable.gid}"
      end
    end
  end
end
