class Catalog::PrintersController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Printer
  end
end
