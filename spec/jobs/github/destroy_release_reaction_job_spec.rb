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
  let!(:repository) { create(:github_repository) }
  let!(:release) { create(:github_release) }
  let!(:reaction) { create(:github_reaction) }

  it "DELETE a reaction from github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    allow(HTTParty).to receive_messages(delete: Github::DeleteResponse.new)

    response = described_class.perform_now(repository, release, reaction.gid)
    expect(response.code).to eq 204
  end
end
