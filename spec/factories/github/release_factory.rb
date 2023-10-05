FactoryBot.define do
  factory :github_release, class: "Github::Release" do
    gid { 122_695_278 }
    name { "wJoenn v1.0.0" }
    tag_name { "v1.0.0" }
    body { "A release" }
    html_url { "https://www.github.com" }
    released_at { 1.day.ago }
    read { false }

    repository { association :github_repository }
    author { association :github_user }
  end
end
