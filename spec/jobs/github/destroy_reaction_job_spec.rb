require "rails_helper"

module Github
  class DeleteResponse
    attr_reader :code

    def initialize
      @code = 204
    end
  end
end

RSpec.describe Github::DestroyReactionJob do
  let!(:reaction) { create(:github_reaction, :with_release) }
  let!(:release) { reaction.reactable }
  let!(:repository) { release.repository }

  before do
    allow(HTTParty).to receive_messages(delete: Github::DeleteResponse.new)
  end

  it "DELETE a Github::Release reaction from github" do
    response = described_class.perform_now(repository, release, reaction.gid)
    expect(response.code).to eq 204
  end
end
