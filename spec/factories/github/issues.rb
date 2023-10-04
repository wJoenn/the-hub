FactoryBot.define do
  factory :github_issue, class: "Github::Issue" do
    gid { 1 }
    html_url { "https://www.github.com" }
    body { "An issue" }
    status { "opened" }
    title { "I have an issue" }
    gh_type { "Issue" }
    number { 1 }
    released_at { 1.day.ago }

    repository { association :github_repository }
    author { association :github_user }
  end
end
