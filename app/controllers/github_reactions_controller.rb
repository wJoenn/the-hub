class GithubReactionsController < ApplicationController
  before_action :set_release, :set_repository, only: %i[create destroy]

  def create
    reaction_params = params.require(:reaction).permit(:content)
    response = Github.new.create_reaction(@repository, @release, reaction_params[:content])

    if [200, 201].include?(response.code)
      reaction = JSON.parse(response.body)
      GithubReaction.create!(
        gid: reaction["id"],
        github_user_id: reaction["user"]["id"],
        content: reaction["content"],
        release: @release
      )

      render :json, status: :created
    else
      render :json, status: :not_found
    end
  end

  def destroy
    reaction = GithubReaction.find_or_initialize_by(gid: params[:id])
    response = Github.new.delete_reaction(@repository, @release, reaction)

    case response.code
    when 204
      reaction.destroy!
      render :json, status: :ok
    when 404 then render :json, status: :not_found
    end
  end

  private

  def set_release
    @release = GithubRelease.by_gid(params[:github_release_id])
  end

  def set_repository
    @repository = GithubRepository.by_gid(params[:github_repository_id])
  end
end
