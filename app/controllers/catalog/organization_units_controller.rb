class Catalog::OrganizationUnitsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = OrganizationUnit
  end
end
