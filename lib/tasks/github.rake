namespace :github do
  desc "TODO"
  task fetch: :environment do
    GithubOctokit.new({ starred_limit: 1, release_limit: 1 }).fetch
  end
end
