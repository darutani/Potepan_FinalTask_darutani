class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
  end

  def index
  end
end
