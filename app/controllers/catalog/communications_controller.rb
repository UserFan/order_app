class Catalog::CommunicationsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Communication
  end
end
