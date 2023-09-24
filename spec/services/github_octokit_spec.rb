require "rails_helper"

RSpec.describe GithubOctokit, type: :service do
  describe "fetch" do
    before(:context) do
      GithubUser.destroy_all
      GithubRepository.destroy_all
      GithubRelease.destroy_all

      described_class.new({ starred_limit: 1, release_limit: 1 }).fetch
      described_class.new({ starred_limit: 1, release_limit: 1 }).fetch
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
end
