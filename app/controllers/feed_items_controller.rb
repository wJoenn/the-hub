class FeedItemsController < ApplicationController
  def index
    @page = params[:page].nil? ? 0 : params[:page].to_i - 1
    render json: { feed_items: serialized_feed_items(queried_feed_items) }, status: :ok
  end

  private

  def queried_feed_items
    FeedItem.includes(:itemable).order(released_at: :desc).limit(10).offset(10 * @page).map(&:itemable)
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
