class Catalog::PositionsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Position
  end
end
