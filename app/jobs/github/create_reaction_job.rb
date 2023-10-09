module Github
  class CreateReactionJob < Github::ApplicationJob
    def perform(repository, reactable, reaction)
      @reactable = reactable
      response = Github::Api.new.create_reaction(repository, reactable_path, reaction)

      reaction.update!(gid: response["id"])
      response
    rescue ActiveRecord::RecordInvalid
      reaction.destroy!
    end
  end
end
