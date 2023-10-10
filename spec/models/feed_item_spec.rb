require "rails_helper"

RSpec.describe FeedItem do
  let!(:itemable) { create(:github_comment) }
  let!(:comment_feed_item) { create(:feed_item, :with_comment) }
  let!(:release_feed_item) { create(:feed_item, :with_release) }

  describe "associations" do
    context "with polymorphism" do
      it "can belong to a Github::Comment" do
        expect(comment_feed_item.itemable).to be_a Github::Comment
      end

      it "can belong to a Github::Release" do
        expect(release_feed_item.itemable).to be_a Github::Release
      end
    end
  end

  describe "validations" do
    it "validates the presence of all attributes" do
      expect(comment_feed_item).to be_persisted

      test_wrong_record(itemable:)
    end

    it "validates the DateTime format of released_date" do
      test_wrong_record(released_at: "a", itemable:)
    end
  end

  private

  def test_wrong_record(params)
    record = described_class.create(params)
    expect(record).not_to be_persisted
  end
end
