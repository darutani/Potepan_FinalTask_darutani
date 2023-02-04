class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.includes(master: [images: { attachment_attachment: :blob }]).find(params[:id])
    @related_products = @product.related_products
  end
end
