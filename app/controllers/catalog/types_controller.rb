class Catalog::TypesController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Type
  end
end
