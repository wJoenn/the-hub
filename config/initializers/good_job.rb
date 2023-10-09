Rails.application.configure do
  config.good_job.execution_mode = :async unless Rails.env.test?

  config.good_job.enable_cron = true

  config.good_job.cron = {
    github_get_comments: {
      cron: "/30 * * * *",
      class: "Github::GetCommentsJob",
      kwargs: { notification_limit: 15, issue_comment_limit: 100, reaction_limit: 100 },
      description: "Fetching Github for new issue comments every 30 minutes"
    },
    github_get_releases: {
      cron: "0 /2 * * *",
      class: "Github::GetReleasesJob",
      kwargs: { starred_limit: 60, release_limit: 3 },
      description: "Fetching Github for new releases every 2 hours"
    }
  }
end
