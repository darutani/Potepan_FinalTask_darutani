class Potepan::ProductsController < ApplicationController
  RELATED_PRODUCTS_MAX_DISPLAY_NUMBER = 4

  def show
    @product = Spree::Product.includes(master: [images: { attachment_attachment: :blob }]).find(params[:id])
    @related_products = @product.related_products.
      includes(master: [:default_price, images: { attachment_attachment: :blob }]).
      limit(RELATED_PRODUCTS_MAX_DISPLAY_NUMBER)
  end
end
