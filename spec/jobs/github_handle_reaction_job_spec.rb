require "rails_helper"

module GithubHandleReactionJobSpec
  class Response
    attr_reader :code

    def initialize
      @code = 204
    end
  end
end

RSpec.describe GithubHandleReactionJob do
  let!(:repository) { create(:github_repository) }
  let!(:release) { create(:github_release) }
  let!(:reaction) { create(:github_reaction) }

  it "POST a new reaction on github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    described_class.perform_now(repository, release, reaction, "create")

    expect(reaction.gid).not_to eq 1
  end

  it "destroys the temporary instance if the POST failed" do
    allow(HTTParty).to receive_messages(post: { "id" => nil })
    described_class.perform_now(repository, release, reaction, "create")

    expect(GithubReaction.count).to eq 0
  end

  it "DELETE a reaction from github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    allow(HTTParty).to receive_messages(delete: GithubHandleReactionJobSpec::Response.new)

    described_class.perform_now(repository, release, reaction, "create")
    response = described_class.perform_now(repository, release, reaction.gid, "delete")
    expect(response.code).to eq 204
  end
end
