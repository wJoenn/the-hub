require "rails_helper"

RSpec.describe Github::CreateReactionJob do
  let!(:comment_reaction) { create(:github_reaction, :with_comment) }
  let!(:issue_reaction) { create(:github_reaction, :with_issue) }
  let!(:release_reaction) { create(:github_reaction, :with_release) }
  let!(:repository) { create(:github_repository) }

  it "POST a new Github::Comment reaction on github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    described_class.perform_now(repository, comment_reaction.reactable, comment_reaction)

    expect(comment_reaction.gid).not_to eq 1
  end

  it "POST a new Github::Issue reaction on github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    described_class.perform_now(repository, issue_reaction.reactable, issue_reaction)

    expect(issue_reaction.gid).not_to eq 1
  end

  it "POST a new Github::Release reaction on github" do
    allow(HTTParty).to receive_messages(post: { "id" => 2 })
    described_class.perform_now(repository, release_reaction.reactable, release_reaction)

    expect(release_reaction.gid).not_to eq 1
  end

  it "destroys the temporary instance if the POST failed" do
    allow(HTTParty).to receive_messages(post: { "id" => nil })
    described_class.perform_now(repository, comment_reaction.reactable, comment_reaction)
    described_class.perform_now(repository, issue_reaction.reactable, issue_reaction)
    described_class.perform_now(repository, release_reaction.reactable, release_reaction)

    expect(Github::Reaction.count).to eq 0
  end
end
