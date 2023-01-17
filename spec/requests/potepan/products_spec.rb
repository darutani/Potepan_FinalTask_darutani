require 'rails_helper'

RSpec.describe "Potepna::Products", type: :request do
  describe "GET /show" do
    let(:product) { create(:product) }

    it "商品の詳細画面を表示すること" do
      get potepan_product_path(product.id)
      expect(response).to have_http_status(:success)
    end
  end

end


