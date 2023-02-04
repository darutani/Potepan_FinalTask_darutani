class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @taxonomies = Spree::Taxonomy.eager_load(:taxons)
    @products = @taxon.all_products.includes(master: [:default_price, images: { attachment_attachment: :blob }])
  end
end
