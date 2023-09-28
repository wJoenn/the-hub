class GithubHandleReactionJob < ApplicationJob
  def perform(repository, release, reaction, action)
    response = Github.new.public_send("#{action}_reaction", repository, release, reaction)

    reaction.update!(gid: response["id"]) if action == "create"
    response
  rescue ActiveRecord::RecordInvalid
    reaction.destroy!
  end
end
