namespace :github do
  task fetch: :environment do
    GithubOctokit.new({ starred_limit: 30, release_limit: 5 }).fetch
  end
end
