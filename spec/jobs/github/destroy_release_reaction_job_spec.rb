require "rails_helper"

module Github
  class DeleteResponse
    attr_reader :code

    def initialize
      @code = 204
    end
  end
end

RSpec.describe Github::DestroyReleaseReactionJob do
  let!(:reaction) { create(:github_reaction, :with_release) }
  let!(:release) { reaction.reactable }
  let!(:repository) { release.repository }

  it "DELETE a reaction from github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    allow(HTTParty).to receive_messages(delete: Github::DeleteResponse.new)

    response = described_class.perform_now(repository, release, reaction.gid)
    expect(response.code).to eq 204
  end
end
