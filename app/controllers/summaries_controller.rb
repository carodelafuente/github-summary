class SummariesController < ApplicationController

  def search
    redirect_to summary_path(params[:q])
  end

  def show
    @summary = Summary.find_or_create_by(username: params[:username])

    if request.xhr?
      if @summary.ready?
        head 200
      else
        head 202
      end
    else
      if !@summary.ready?
        GithubSummaryJob.perform_later(@summary)
      end
    end


  end

end
