module Github
  class Comment < ApplicationRecord
    include IsGithubModel

    has_many :reactions, class_name: "Github::Reaction", inverse_of: :reactable, dependent: :destroy

    belongs_to :author, class_name: "Github::User"
    belongs_to :issue, class_name: "Github::Issue"

    validates :html_url, :released_at, presence: true
    validates :read, inclusion: [true, false]
    validates :feed_type, format: { with: /\AGithubComment\z/ }
    validate :released_at_is_a_datetime

    def reactions
      Github::Reaction.where(reactable_type: "Github::Comment", reactable_id: id)
    end

    private

    def released_at_is_a_datetime
      errors.add(:released_at, "must be a valid date") unless released_at.is_a? ActiveSupport::TimeWithZone
    end
  end
end
