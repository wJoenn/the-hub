class AddPolymorphicReferenceToGithubReactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :github_reactions, :reactable, polymorphic: true

    reversible do |dir|
      dir.up do
        Github::Reaction.update_all("reactable_id = release_id, reactable_type = 'Github::Release'")
      end

      dir.down do
        Github::Reaction.update_all("release_id = reactable_id")
      end
    end

    remove_reference :github_reactions, :release, index: true, foreign_key: { to_table: :github_releases }
  end
end
