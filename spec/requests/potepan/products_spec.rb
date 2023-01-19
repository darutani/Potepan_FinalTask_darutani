require 'rails_helper'

RSpec.describe "Potepna::Products", type: :request do
  describe "GET /show" do
    let(:product) { create(:product) }

    before do
      get potepan_product_path(product.id)
    end

    it "商品の詳細画面を表示すること" do
      expect(response).to have_http_status(:success)
    end

    it "正しい商品情報が取得できていること" do
      expect(response.body).to include product.name
      expect(response.body).to include product.price.to_s
    end
  end
end
