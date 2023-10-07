module Github
  class Issue < ApplicationRecord
    include IsGithubModel

    has_many :comments, class_name: "Github::Comment", inverse_of: :issue, dependent: :destroy
    has_many :reactions, class_name: "Github::Reaction", inverse_of: :reactable, dependent: :destroy

    belongs_to :author, class_name: "Github::User"
    belongs_to :repository, class_name: "Github::Repository"

    validates :html_url, :state, :title, :gh_type, :number, :released_at, presence: true
    validates :number, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validate :released_at_is_a_datetime

    def released_at_is_a_datetime
      errors.add(:released_at, "must be a valid date") unless released_at.is_a? ActiveSupport::TimeWithZone
    end
  end
end
