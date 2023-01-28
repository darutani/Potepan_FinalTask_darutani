require 'rails_helper'

RSpec.describe "Potepna::Products", type: :request do
  describe "GET /show" do
    let(:product) { create(:product) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get potepan_product_path(product.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = request.base_url
      product.reload
      image.reload
    end

    it "正しいHTTPレスポンスを返すこと" do
      expect(response).to have_http_status(:success)
    end

    it "正しい商品情報が取得できていること" do
      expect(response.body).to include "#{product.name} - BIGBAG Store"
      expect(response.body).to include product.name
      expect(response.body).to include product.price.to_s
      expect(response.body).to include product.description
      product.images.each { |image| expect(response.body).to include(image.attachment(:large)) }
      product.images.each { |image| expect(response.body).to include(image.attachment(:small)) }
    end
  end
end
