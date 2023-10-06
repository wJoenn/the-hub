require "rails_helper"

RSpec.describe Github::CreateReleaseReactionJob do
  let!(:reaction) { create(:github_reaction, :with_release) }
  let!(:release) { reaction.reactable }
  let!(:repository) { release.repository }

  it "POST a new reaction on github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    described_class.perform_now(repository, release, reaction)

    expect(reaction.gid).not_to eq 1
  end

  it "destroys the temporary instance if the POST failed" do
    allow(HTTParty).to receive_messages(post: { "id" => nil })
    described_class.perform_now(repository, release, reaction)

    expect(Github::Reaction.count).to eq 0
  end
end
