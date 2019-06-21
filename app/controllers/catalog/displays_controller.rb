class Catalog::DisplaysController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Display
  end
end
