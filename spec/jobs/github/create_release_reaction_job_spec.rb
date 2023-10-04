require "rails_helper"

RSpec.describe Github::CreateReleaseReactionJob do
  let!(:repository) { create(:github_repository) }
  let!(:release) { create(:github_release) }
  let!(:reaction) { create(:github_reaction) }

  it "POST a new reaction on github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    described_class.perform_now(repository, release, reaction)

    expect(reaction.gid).not_to eq 1
  end

  it "destroys the temporary instance if the POST failed" do
    allow(HTTParty).to receive_messages(post: { "id" => nil })
    described_class.perform_now(repository, release, reaction)

    expect(GithubReaction.count).to eq 0
  end
end
