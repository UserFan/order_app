class Catalog::KeyboardsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Keyboard
  end
end
