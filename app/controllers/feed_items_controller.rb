class FeedItemsController < ApplicationController
  def index
    render json: { feed_items: serialized_feed_items(queried_feed_items) }, status: :ok
  end

  private

  def queried_feed_items
    github_comments = Github::CommentsController.new.send(:queried_comments)
    github_releases = Github::ReleasesController.new.send(:queried_releases)

    (github_comments + github_releases).sort_by(&:released_at).last(30).reverse
  end

  def serialized_feed_items(items)
    items.map do |item|
      item_class_name = item.class.to_s
      item_name = item_class_name.underscore.delete_prefix("github/")
      item_controller_class = Object.const_get("#{item_class_name}sController")

      item_controller_class.new.send("serialized_#{item_name}s", [item]).first
    end
  end
end
