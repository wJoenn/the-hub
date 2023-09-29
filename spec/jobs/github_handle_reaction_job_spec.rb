require "rails_helper"

RSpec.describe GithubHandleReactionJob do
  let!(:owner) do
    GithubUser.create!(gid: 1, login: "wJoenn", gh_type: "User", avatar_url: "wJoenn/avatar", html_url: "wJoenn/html")
  end

  let!(:repository) do
    GithubRepository.create!(gid: 1, full_name: "wJoenn/TheHub", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:fake_repository) do
    GithubRepository.create!(gid: 1, full_name: "wJoenn/TheFakeHub", name: "wJoenn", description: "A repo", owner:)
  end

  let!(:release) do
    GithubRelease.create!(
      gid: 122_695_278,
      name: "wJoenn v1.0.0",
      tag_name: "v1.0.0",
      html_url: "https://www.github.com",
      release_date: Time.current,
      repository:,
      author: owner
    )
  end

  let!(:reaction) { GithubReaction.create!(gid: 1, github_user_id: 75_388_869, content: "+1", release:) }

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
