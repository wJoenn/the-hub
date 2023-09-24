class GithubRelease < ApplicationRecord
  include IsGithubModel

  belongs_to :repository, class_name: "GithubRepository"

  validates :name, :tag_name, :release_date, presence: true
  validates :reactions_plus_one,
    :reactions_minus_one,
    :reactions_confused,
    :reactions_eyes,
    :reactions_heart,
    :reactions_hooray,
    :reactions_laugh,
    :reactions_rocket,
    numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :read, inclusion: [true, false]
  validate :release_date_is_a_date

  def release_date_is_a_date
    errors.add(:release_date, "must be a valid date") unless release_date.is_a? Time
  end
end
