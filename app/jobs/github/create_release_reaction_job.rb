module Github
  class CreateReleaseReactionJob < ApplicationJob
    def perform(repository, release, reaction)
      response = Github::Api.new.create_release_reaction(repository, release, reaction)

      reaction.update!(gid: response["id"])
      response
    rescue ActiveRecord::RecordInvalid
      reaction.destroy!
    end
  end
end
