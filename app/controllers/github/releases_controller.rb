module Github
  class ReleasesController < Github::ApplicationController
    def index
      render json: { releases: serialized_releases }, status: :ok
    end

    private

    def queried_releases
      Github::Release.includes(:author, repository: :owner).order(released_at: :desc).limit(30)
    end

    def serialized_releases
      queried_releases.map do |release|
        {
          id: release.gid,
          name: release.name,
          tag_name: release.tag_name,
          body: release.body,
          html_url: release.html_url,
          read: release.read?,
          feed_type: release.feed_type,
          released_at: release.released_at,
          reactions: serialized_reactions(release),
          repository: serialized_repository(release.repository),
          author: serialized_user(release.author)
        }
      end
    end
  end
end
