class FeedItem < ApplicationRecord
  belongs_to :itemable, polymorphic: true

  validates :released_at, presence: true
  validate :released_at_is_a_datetime

  private

  def released_at_is_a_datetime
    errors.add(:released_at, "must be a valid date") unless released_at.is_a? ActiveSupport::TimeWithZone
  end
end
