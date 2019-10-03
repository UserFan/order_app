class EspCertPolicy < UnitPolicy

  def export_xls?
    (!access_not?('default') && !access_not?('export')) || user.super_admin?
  end

  class Scope < Scope
    def resolve
      if access_set('default') == EnumTypeAccess::ALLALOWED || user.super_admin?
        scope.includes(:shop, :esp).order('shops.name asc').all
      elsif access_set('default') == EnumTypeAccess::READONLY || EnumTypeAccess::READWRITEONLY
        scope.joins(:esp).where(esps: { shop_id: user.current_shops })
      end
    end
  end

  def permitted_attributes
    [:date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
     :date_start_rsa, :date_end_rsa] if user.super_admin? || access_write?('default') || access_all?('default')
  end
end
