class Catalog::StatusesController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Status
  end
end
