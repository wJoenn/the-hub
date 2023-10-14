class FeedItemsController < ApplicationController
  def index
    @from_date = params[:from_date].nil? ? Time.current : params[:from_date].to_datetime
    render json: { feed_items: serialized_feed_items(queried_feed_items) }, status: :ok
  end

  private

  def queried_feed_items
    github_comments = Github::Comment
      .includes(:author, :reactions, issue: [:author, :reactions, { repository: :owner }])
      .joins(:author)
      .where("github_comments.released_at < ?", @from_date)
      .where.not(author: { gid: Rails.application.credentials.github_user_id })
      .order(released_at: :desc)
      .limit(10)

    github_releases = Github::Release
      .includes(:author, :reactions, repository: :owner)
      .where("released_at < ?", @from_date)
      .order(released_at: :desc)
      .limit(10)

    (github_comments + github_releases).sort_by(&:released_at).last(10).reverse
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
