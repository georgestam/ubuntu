class StatsController < ApplicationController
  def index
    policy_scope(User)
  end
  
  def data
    skip_authorization
    respond_to do |format|
      format.json {
        render :json => [1,2,3,4,5]
      }
    end
  end
  
end
