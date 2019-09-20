class ReportCostServicePolicy < ApplicationPolicy

  def remove_service_report?
    (access_all?('remove_positions') || user.super_admin?) &&
    record.status_id != Status::MADE
  end

  def closing_report?
    (access_all?('closing_report') ||  user.super_admin?) &&
    record.status_id != Status::MADE
  end

  def open_report?
    (access_all?('rollback_report') || user.super_admin?) &&
    (record.status_id == Status::MADE)
  end

  def destroy?
    (access_all?('destroy') || user.super_admin?)
  end

  def report_service?
    (access_all?('export') || user.super_admin?) &&
    record.status_id == Status::MADE
  end

  def permitted_attributes
    [:date_report, :status_id, :name_report, :type_service, :comment] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
