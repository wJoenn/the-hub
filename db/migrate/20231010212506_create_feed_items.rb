class CreateFeedItems < ActiveRecord::Migration[7.1]
  def change
    create_table :feed_items do |t|
      t.datetime :released_at, null: false, index: true
      t.references :itemable, polymorphic: true

      t.timestamps
    end

    Github::Comment.find_each { |comment| comment.create_feed_item(released_at: comment.released_at) }
    Github::Release.find_each { |release| release.create_feed_item(released_at: release.released_at) }
  end
end
