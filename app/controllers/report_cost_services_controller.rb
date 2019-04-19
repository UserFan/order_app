class ReportCostServicesController < ApplicationController
  before_action :set_report, except: [ :index, :new, :create ]
  before_action :set_service_type, only: [ :new, :create ]
  after_action :verify_authorized

  def index
    authorize ReportCostService
    @q = ReportCostService.includes(:service_equipments).ransack(params[:q])
    @q.sorts = ['date_report asc', 'created_at desc'] if @q.sorts.empty?
    @report_services = @q.result(disinct: true)
  end

  def show
    authorize @report_service
  end

  def new
    authorize ReportCostService
    @report_service = ReportCostService.new(date_report: Date.today.end_of_month,
                                            status_id: Status::GENERATED)

  end

  def edit
    authorize(@report_service)
    render 'show'
  end

  def create
    authorize ReportCostService
    service_if = {}
    @report_service =
      ReportCostService.new(permitted_attributes(ReportCostService).
                            merge(status_id: Status::GENERATED))
      service_if = {date_service: @report_service.date_report..@report_service.date_report.end_of_month,
                             report_cost_service_id: 0}
      service_if.merge!(equipment_type_id: @report_service.type_service) if @report_service.type_service.present?
      services = ServiceEquipment.where(service_if)

    if services.present?
      @report_service.save
      services.each do |service|
        service.update_attributes!(report_cost_service_id: @report_service.id)
      end
      redirect_to report_cost_service_path(@report_service)
    else
      flash[:error] = t('.error')
      render 'new'
    end
  end

  def update
    authorize @report_service
    if @report_service.update_attributes(permitted_attributes(@report_service))
      @report_service.save
      redirect_to report_cost_service_path(@report_service)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @report_service
    services = ServiceEquipment.where(report_cost_service_id: @report_service.id)
    services.each do |service|
      service.update_attributes!(report_cost_service_id: 0)
    end
    if @report_service.destroy
      flash[:success] = t('.success')
    else
      flash[:error] = t('.error')
    end
    redirect_to report_cost_services_path
  end

  def remove_service_report
    authorize @report_service
    service = ServiceEquipment.find(params[:service_id])
    if service.update_attributes(report_cost_service_id: 0)
      service.save
      flash[:success] = t('.success')
    else
      flash[:error] = t('.error')
      render 'show'
    end
    unless @report_service.service_equipments.present?
      @report_service.destroy
      flash[:success] = t('.success_report')
      redirect_to report_cost_services_path
    else
      render 'show'
    end
  end

  def closing_report
    authorize @report_service

    @report_service.update_attributes!(status_id: Status::MADE)
    redirect_to report_cost_services_path
  end

  def open_report
    authorize @report_service
    @report_service.update_attributes!(status_id: Status::GENERATED)
    redirect_to report_cost_services_path
  end

  def report_service
    authorize @report_service
    respond_to do |format|
      format.xlsx {
        render xlsx: "report_service", filename: "report.xlsx"
        }
    end
  end

  private

  def set_report
    @report_service ||= ReportCostService.find(params[:id])
    @services = @report_service.service_equipments
    @service_count = @services.count
  end

  def set_service_type
    @type_services =
      EquipmentType.where(id: ServiceEquipment.distinct.pluck(:equipment_type_id))
  end

end
