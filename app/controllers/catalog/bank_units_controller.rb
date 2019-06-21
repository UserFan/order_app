class Catalog::BankUnitsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = BankUnit
  end
end
