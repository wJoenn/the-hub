require "rails_helper"

class Comment
  attr_reader :id, :body, :html_url, :created_at, :user, :issue

  def initialize
    @id = 1
    @body = "a"
    @html_url = "a"
    @created_at = Time.current
    @user = User.new
    @issue = Issue.new
  end
end

class Issue
  attr_reader :id, :body, :html_url, :state, :title, :gh_type, :number, :created_at, :user, :repository

  def initialize
    @id = 1
    @body = "a"
    @html_url = "a"
    @state = "a"
    @title = "a"
    @gh_type = "a"
    @number = 1
    @created_at = Time.current
    @user = User.new
    @repository = Repository.new
  end
end

class Repository
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

RSpec.describe Github::GetCommentsJob do
  let!(:client) { Octokit::Client.new(access_token: Rails.application.credentials.github_token) }

  before do
    allow(Octokit::Client).to receive_messages(new: client)
    allow(client).to receive_messages(repository: Repository.new)
    allow(client).to receive_messages(issue: Issue.new)
    allow(client).to receive_messages(user: User.new)
    allow(client).to receive_messages(issue_comments: [Comment.new])
    allow(client).to receive_messages(markdown: "")

    described_class.perform_now
    described_class.perform_now
  end

  it "finds or create new Github::User" do
    expect(Github::User.count).to eq 1
  end

  it "finds or create new Github::Repository" do
    expect(Github::Repository.count).to eq 1
  end

  it "finds or create new Github::Issue" do
    expect(Github::Issue.count).to eq 1
  end

  it "finds or create new Github::Comment" do
    expect(Github::Comment.count).to eq 1
  end
end
