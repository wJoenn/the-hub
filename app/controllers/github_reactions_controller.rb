class GithubReactionsController < ApplicationController
  before_action :set_release, :set_repository, only: %i[create destroy]

  def create
    reaction_params = params.require(:github_reaction).permit(:content)
    reaction = GithubReaction.create!(
      gid: 0,
      github_user_id: 75_388_869,
      content: reaction_params[:content],
      release: @release
    )

    GithubHandleReactionJob.perform_later(@repository, @release, reaction, "create")

    render json: serialized_reaction(reaction), status: :created
  rescue ActiveRecord::RecordInvalid
    render :json, status: :unprocessable_entity
  end

  def destroy
    reaction = GithubReaction.find_or_initialize_by(id: params[:id])
    reaction.destroy!

    GithubHandleReactionJob.perform_later(@repository, @release, reaction, "delete")

    render :json, status: :ok
  end

  private

  def set_release
    @release = GithubRelease.by_gid(params[:github_release_id])
  end

  def set_repository
    @repository = GithubRepository.by_gid(params[:github_repository_id])
  end

  def serialized_reaction(reaction)
    {
      id: reaction.gid,
      user_id: reaction.github_user_id,
      content: reaction.content
    }
  end
end
