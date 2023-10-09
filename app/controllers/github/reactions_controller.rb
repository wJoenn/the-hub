module Github
  class ReactionsController < ApplicationController
    before_action :set_reactable, :set_repository, only: %i[create destroy]

    def create
      reaction_params = params.require(:reaction).permit(:content)
      reaction = Github::Reaction.create!(
        gid: 0,
        github_user_id: 75_388_869,
        content: reaction_params[:content],
        reactable: @reactable
      )

      Github::CreateReactionJob.perform_later(@repository, @reactable, reaction)

      render json: serialized_reaction(reaction), status: :created
    rescue ActiveRecord::RecordInvalid
      render :json, status: :unprocessable_entity
    end

    def destroy
      reaction = Github::Reaction.find_or_initialize_by(id: params[:id])
      gid = reaction.gid
      reaction.destroy!

      Github::DestroyReactionJob.perform_later(@repository, @reactable, gid)

      render :json, status: :ok
    end

    private

    def set_reactable
      return @reactable = Github::Comment.by_gid(params[:comment_id]) if params[:comment_id]
      return @reactable = Github::Issue.by_gid(params[:issue_id]) if params[:issue_id]

      @reactable = Github::Release.by_gid(params[:release_id])
    end

    def set_repository
      @repository = Github::Repository.by_gid(params[:repository_id])
    end

    def serialized_reaction(reaction)
      {
        id: reaction.id,
        user_id: reaction.github_user_id,
        content: reaction.content
      }
    end
  end
end
