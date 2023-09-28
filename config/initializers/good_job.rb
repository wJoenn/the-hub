Rails.application.configure do
  config.good_job.execution_mode = :async unless Rails.env.test?

  config.good_job.enable_cron = true

  config.good_job.cron = {
    github_get_releases: {
      cron: ->(last_ran) { (last_ran.blank? ? Time.current : last_ran + 2.hours).at_beginning_of_minute },
      class: "GithubFetchReleasesJob",
      kwargs: { starred_limit: 60, release_limit: 5 },
      description: "Fetching Github for new releases"
    }
  }
end
