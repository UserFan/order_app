class Catalog::CategoriesController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Category
  end
end
