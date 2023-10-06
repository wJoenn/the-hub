module Github
  class Comment < ApplicationRecord
    include IsGithubModel

    belongs_to :author, class_name: "Github::User"
    belongs_to :issue, class_name: "Github::Issue"

    validates :html_url, :released_at, presence: true
    validates :read, inclusion: [true, false]
    validate :released_at_is_a_datetime

    def released_at_is_a_datetime
      errors.add(:released_at, "must be a valid date") unless released_at.is_a? ActiveSupport::TimeWithZone
    end
  end
end
