module Github
  class Comment < ApplicationRecord
    include IsGithubModel

    has_one :feed_item, class_name: "FeedItem", as: :itemable, dependent: :destroy

    has_many :reactions, class_name: "Github::Reaction", as: :reactable, dependent: :destroy

    belongs_to :author, class_name: "Github::User"
    belongs_to :issue, class_name: "Github::Issue"

    validates :html_url, :released_at, presence: true
    validates :read, inclusion: [true, false]
    validates :feed_type, format: { with: /\AGithubComment\z/ }
    validate :released_at_is_a_datetime

    private

    def released_at_is_a_datetime
      errors.add(:released_at, "must be a valid date") unless released_at.is_a? ActiveSupport::TimeWithZone
    end
  end
end
