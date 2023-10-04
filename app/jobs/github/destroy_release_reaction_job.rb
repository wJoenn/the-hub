module Github
  class DestroyReleaseReactionJob < ApplicationJob
    def perform(repository, release, reaction_gid)
      Github::Api.new.delete_release_reaction(repository, release, reaction_gid)
    end
  end
end
