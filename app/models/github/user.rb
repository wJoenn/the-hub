module Github
  class User < ApplicationRecord
    include IsGithubModel

    has_many :issues,
      class_name: "Github::Issue",
      foreign_key: "author_id",
      inverse_of: :author,
      dependent: :destroy

    has_many :releases,
      class_name: "Github::Release",
      foreign_key: "author_id",
      inverse_of: :author,
      dependent: :destroy

    has_many :repositories,
      class_name: "Github::Repository",
      foreign_key: "owner_id",
      inverse_of: :owner,
      dependent: :destroy

    validates :login, :gh_type, :avatar_url, :html_url, presence: true
  end
end
