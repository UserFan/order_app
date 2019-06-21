class ReportCostServicePolicy < ApplicationPolicy

  def remove_service_report?
    user.super_admin?
    record.status_id != Status::MADE
  end

  def closing_report?
    remove_service_report?
  end

  def open_report?
    report_service?
  end

  def destroy?
    remove_service_report?
  end

  def report_service?
    user.super_admin? &&
    record.status_id == Status::MADE
  end

  def permitted_attributes
    [:date_report, :status_id, :name_report, :type_service, :comment] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
