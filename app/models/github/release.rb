module Github
  class Release < ApplicationRecord
    include IsGithubModel

    self.table_name = "github_releases"

    has_many :reactions,
      class_name: "Github::Reaction",
      foreign_key: "release_id",
      inverse_of: :release,
      dependent: :destroy

    belongs_to :author, class_name: "Github::User"
    belongs_to :repository, class_name: "Github::Repository"

    validates :name, :tag_name, :release_date, :html_url, presence: true
    validates :read, inclusion: [true, false]
    validate :release_date_is_a_datetime

    def release_date_is_a_datetime
      errors.add(:release_date, "must be a valid date") unless release_date.is_a? ActiveSupport::TimeWithZone
    end
  end
end
