module Github
  class Reaction < ApplicationRecord
    include IsGithubModel

    belongs_to :reactable, polymorphic: true

    validates :github_user_id, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :content, presence: true, inclusion: %w[+1 -1 confused eyes heart hooray laugh rocket]
  end

  def reactable
    Objedct.const(reactable_type).find(reactable_id)
  end
end
