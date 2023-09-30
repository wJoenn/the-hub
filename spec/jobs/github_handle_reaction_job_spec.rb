require "rails_helper"

RSpec.describe GithubHandleReactionJob do
  let!(:repository) { create(:github_repository) }
  let!(:fake_repository) { create(:github_repository, :is_fake) }
  let!(:release) { create(:github_release) }
  let!(:reaction) { create(:github_reaction) }

  before do
    described_class.perform_now(repository, release, reaction, "create")
  end

  it "POST a new reaction on github" do
    described_class.perform_now(repository, release, reaction, "create")
    expect(reaction.gid).not_to eq 1
  end

  it "destroys the temporary instance if the POST failed" do
    described_class.perform_now(fake_repository, release, reaction, "create")
    expect(GithubReaction.count).to eq 0
  end

  it "DELETE a reaction from github" do
    response = described_class.perform_now(repository, release, reaction.gid, "delete")
    expect(response.code).to eq 204
  end
end
