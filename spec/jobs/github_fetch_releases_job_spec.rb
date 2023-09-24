require "rails_helper"

RSpec.describe GithubFetchReleasesJob do
  before do
    described_class.perform_now({ starred_limit: 1, release_limit: 1 })
    described_class.perform_now({ starred_limit: 1, release_limit: 1 })
  end

  it "finds or create new GithubUser" do
    expect(GithubUser.count).to be >= 1
  end

  it "finds or create new GithubRepository" do
    expect(GithubRepository.count).to eq 1
  end

  it "finds or create new GithubRelease" do
    expect(GithubRelease.count).to eq 1
  end
end
