class GithubSummaryJob < ApplicationJob
  queue_as :default

  def perform(*summary)
    # binding.pry
    summary.get_user
    summary.get_repos
    summary.save
    @username = summary.username
    @user = summary.user
    @repos = summary.repos
    @languages = summary.languages
  end
end
