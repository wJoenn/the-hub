Rails.application.configure do
  config.good_job.execution_mode = :async unless Rails.env.test?

  config.good_job.enable_cron = true

  config.good_job.cron = {
    github_get_comments_morning: {
      cron: "0 4 * * *",
      class: "Github::GetCommentsJob",
      kwargs: { notification_limit: 15, issue_comment_limit: 100, reaction_limit: 100 },
      description: "Fetching Github for new issue comments"
    },
    github_get_releases_morning: {
      cron: "0 5 * * *",
      class: "Github::GetReleasesJob",
      kwargs: { starred_limit: 60, release_limit: 3 },
      description: "Fetching Github for new releases"
    },
    github_get_comments_noon: {
      cron: "0 9 * * *",
      class: "Github::GetCommentsJob",
      kwargs: { notification_limit: 5, issue_comment_limit: 100, reaction_limit: 100 },
      description: "Fetching Github for new issue comments"
    },
    github_get_releases_noon: {
      cron: "0 10 * * *",
      class: "Github::GetReleasesJob",
      kwargs: { starred_limit: 60, release_limit: 3 },
      description: "Fetching Github for new releases"
    },
    github_get_comments_afternoon: {
      cron: "0 14 * * *",
      class: "Github::GetCommentsJob",
      kwargs: { notification_limit: 5, issue_comment_limit: 100, reaction_limit: 100 },
      description: "Fetching Github for new issue comments"
    },
    github_get_releases_afternoon: {
      cron: "0 15 * * *",
      class: "Github::GetReleasesJob",
      kwargs: { starred_limit: 60, release_limit: 3 },
      description: "Fetching Github for new releases"
    }
  }
end
