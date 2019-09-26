class Catalog::ProvidersController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Provider
  end
end
