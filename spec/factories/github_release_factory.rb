FactoryBot.define do
  factory :github_release do
    gid { 122_695_278 }
    name { "wJoenn v1.0.0" }
    tag_name { "v1.0.0" }
    body { "A release" }
    html_url { "https://www.github.com" }
    release_date { 1.day.ago }
    read { false }

    repository { create(:github_repository) }
    author { create(:github_user) }
  end
end
