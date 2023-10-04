require "rails_helper"

module Github
  class GetResponse
    attr_reader :body

    def initialize
      @body = [{
        "id" => 1,
        "user" => {
          "id" => 1
        },
        "content" => "+1"
      }].to_json
    end
  end
end

class Release
  attr_reader :id, :name, :tag_name, :body, :html_url, :created_at, :author

  def initialize
    @id = 1
    @name = "a"
    @tag_name = "a"
    @body = "a"
    @html_url = "a"
    @created_at = Time.current
    @author = User.new
  end
end

class Starred
  attr_reader :id, :name, :full_name, :description, :language, :stargazers_count, :forks_count, :html_url,
    :pushed_at, :owner

  def initialize
    @id = 1
    @name = "a"
    @full_name = "a"
    @description = "a"
    @language = "a"
    @stargazers_count = 1
    @forks_count = 1
    @html_url = "a"
    @pushed_at = Time.current
    @owner = User.new
  end
end

class User
  attr_reader :id, :login, :type, :avatar_url, :html_url, :name, :bio, :location

  def initialize
    @id = 1
    @login = "a"
    @type = "a"
    @avatar_url = "a"
    @html_url = "a"
    @name = "a"
    @nio = "a"
    @location = "a"
  end
end

RSpec.describe Github::GetReleasesJob do
  let!(:client) { Octokit::Client.new(access_token: Rails.application.credentials.github_token) }

  before do
    allow(Octokit::Client).to receive_messages(new: client)
    allow(client).to receive_messages(starred: [Starred.new])
    allow(client).to receive_messages(releases: [Release.new])
    allow(client).to receive_messages(user: User.new)
    allow(HTTParty).to receive_messages(get: Github::GetResponse.new)

    described_class.perform_now({ reaction_limit: 1 })
    described_class.perform_now({ reaction_limit: 1 })
  end

  it "finds or create new GithubUser" do
    expect(Github::User.count).to be >= 1
  end

  it "finds or create new GithubRepository" do
    expect(Github::Repository.count).to eq 1
  end

  it "finds or create new GithubRelease" do
    expect(Github::Release.count).to eq 1
  end

  it "finds or create new GithubReaction" do
    expect(Github::Reaction.count).to be >= 1
  end
end
