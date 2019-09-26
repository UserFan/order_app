class Catalog::WeighersController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Weigher
  end
end
