class Catalog::ApcsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Apc
  end
end
