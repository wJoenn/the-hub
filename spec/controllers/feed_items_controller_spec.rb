require "rails_helper"

RSpec.describe FeedItemsController, type: :request do
  describe "GET /index" do
    before do
      create(:feed_item, :with_comment)
      create(:feed_item, :with_release)
      get "/feed_items"
    end

    it "responds with a status of 200" do
      expect(response).to have_http_status :ok
    end

    it "returns a JSON object" do
      expect(response.body).to be_a String
      expect(response.parsed_body).to have_key "feed_items"
    end

    it "returns an array of comments" do
      feed_types = response.parsed_body["feed_items"].pluck("feed_type")
      expect(feed_types).to contain_exactly "GithubRelease", "GithubComment"
    end
  end
end
