class GithubSummaryJob < ApplicationJob
  queue_as :default

  def perform(summary)
    summary.get_user
    summary.get_repos
    summary.save
  end
end
