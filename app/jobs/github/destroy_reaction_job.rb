module Github
  class DestroyReactionJob < Github::ApplicationJob
    def perform(repository, reactable, reaction_gid)
      @reactable = reactable
      Github::Api.new.delete_reaction(repository, reactable_path, reaction_gid)
    end
  end
end
