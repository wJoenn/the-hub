module IsGithubModel
  extend ActiveSupport::Concern

  included do
    validates :gid, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  end

  class_methods do
    def by_gid(gid)
      find_by(gid:)
    end

    def table_name_prefix
      "github_"
    end
  end
end
