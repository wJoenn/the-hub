class GithubReleasesController < ApplicationController
  def index
    render json: { releases: serialized_releases }, status: :ok
  end

  private

  def queried_releases
    GithubRelease.includes(:author, repository: :owner).order(release_date: :desc).limit(30)
  end

  def serialized_reactions(release)
    {
      "+1": {
        amount: release.reactions.where(content: "+1").count,
        reacted: release.reactions.exists?(content: "+1", github_user_id: 75_388_869)
      },
      "-1": {
        amount: release.reactions.where(content: "-1").count,
        reacted: release.reactions.exists?(content: "-1", github_user_id: 75_388_869)
      },
      confused: {
        amount: release.reactions.where(content: "confused").count,
        reacted: release.reactions.exists?(content: "confused", github_user_id: 75_388_869)
      },
      eyes: {
        amount: release.reactions.where(content: "eyes").count,
        reacted: release.reactions.exists?(content: "eyes", github_user_id: 75_388_869)
      },
      heart: {
        amount: release.reactions.where(content: "heart").count,
        reacted: release.reactions.exists?(content: "heart", github_user_id: 75_388_869)
      },
      hooray: {
        amount: release.reactions.where(content: "hooray").count,
        reacted: release.reactions.exists?(content: "hooray", github_user_id: 75_388_869)
      },
      laugh: {
        amount: release.reactions.where(content: "laugh").count,
        reacted: release.reactions.exists?(content: "laugh", github_user_id: 75_388_869)
      },
      rocket: {
        amount: release.reactions.where(content: "rocket").count,
        reacted: release.reactions.exists?(content: "rocket", github_user_id: 75_388_869)
      }
    }
  end

  def serialized_releases
    queried_releases.map do |release|
      {
        id: release.gid,
        name: release.name,
        tag_name: release.tag_name,
        body: release.body,
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
      owner: serialized_user(repository.owner)
    }
  end

  def serialized_user(user)
    {
      id: user.gid,
      login: user.login,
      type: user.gh_type,
      avatar_url: user.avatar_url,
      html_url: user.html_url
    }
  end
end
