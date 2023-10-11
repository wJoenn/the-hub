module IsFeedItem
  extend ActiveSupport::Concern

  included do
    after_create do
      create_feed_item(released_at:)
    end

    has_one :feed_item, class_name: "FeedItem", as: :itemable, dependent: :destroy
  end
end
