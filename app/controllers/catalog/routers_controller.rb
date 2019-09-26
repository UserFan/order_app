class Catalog::RoutersController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Router
  end
end
