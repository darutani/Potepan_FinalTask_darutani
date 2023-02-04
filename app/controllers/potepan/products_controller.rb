class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.includes(master: [images: { attachment_attachment: :blob }]).find(params[:id])
    @related_products = @product.related_products.includes(master: [:default_price, images: { attachment_attachment: :blob }]).limit(4)
  end
end
  