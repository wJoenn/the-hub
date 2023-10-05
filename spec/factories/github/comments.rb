FactoryBot.define do
  factory :github_comment, class: "Github::Comment" do
    gid { 1 }
    html_url { "https://www.github.com" }
    body { "A comment" }
    released_at { 1.day.ago }
    read { false }

    issue { association :github_issue }
    author { association :github_user }
  end
end
