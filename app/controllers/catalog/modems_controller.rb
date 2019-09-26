class Catalog::ModemsController < Catalog::CatalogController
  def catalog_model_name
    @catalog_model = Modem
  end
end
