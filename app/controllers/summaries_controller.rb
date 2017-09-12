class SummariesController < ApplicationController

  def search
    redirect_to summary_path(params[:q])
  end

  def show
    @summary = Summary.find_or_create_by(username: params[:username])

    GithubSummaryJob.perform_later(@summary)
    # @summary.get_user
    # @summary.get_repos
    # @summary.save
    # @username = @summary.username
    # @user = @summary.user
    # @repos = @summary.repos
    # @languages = @summary.languages

    if request.xhr?
      if @summary.ready?
        head 200
      else
        head 202
      end
    end





  end

end
