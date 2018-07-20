class VersionUpdateLogsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize VersionUpdateLog
    @q = VersionUpdateLog.includes(:shop).ransack(params[:q])
    @q.sorts = ['date_log desc', 'created_at desc'] if @q.sorts.empty?
    @version_update_logs = @q.result(disinct: true)
  end


end
