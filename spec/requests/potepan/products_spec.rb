require 'rails_helper'

RSpec.describe "Potepna::Products", type: :request do
  describe "GET /showのメイン部分(.singleproduct部分)" do
    let(:taxon) { create(:taxon) }
    let(:product) { create(:product, taxons: [taxon]) }
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

  describe "GET /showの関連商品欄(.productsContent部分)" do
    let!(:taxon_jacket) { create(:taxon, name: "jackets") }
    let!(:taxon_hat) { create(:taxon, name: "hats") }
    let!(:taxon_html) { create(:taxon, name: "HTML") }
    let!(:taxon_css) { create(:taxon, name: "CSS") }
    let!(:product_jacket_1) { create(:product, name: "potepan-jacket-1", taxons: [taxon_jacket, taxon_html]) }
    let!(:product_jacket_2) { create(:product, name: "potepan-jacket-2", price: "20.99", taxons: [taxon_jacket, taxon_css]) }
    let!(:product_hat_1) { create(:product, name: "potepan-hat-1", price: "30.99", taxons: [taxon_hat, taxon_html]) }
    let!(:product_hat_2) { create(:product, name: "potepan-hat-2", price: "40.99", taxons: [taxon_hat, taxon_css]) }
    let!(:image_1) { create(:image) }
    let!(:image_2) { create(:image) }
    let!(:image_3) { create(:image) }
    let!(:image_4) { create(:image) }

    before do
      product_jacket_1.images << image_1
      product_jacket_2.images << image_2
      product_hat_1.images << image_3
      product_hat_2.images << image_4
      get potepan_product_path(product_jacket_1.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = request.base_url
    end

    it "関連商品の正しい商品情報が取得できていること" do
      within ".related-product" do
        expect(response.body).to include product_jacket_1.name
        expect(response.body).to include product_jacket_1.price.to_s
        expect(response.body).to include(product_jacket_1.display_image.attachment(:small))
        expect(response.body).to include product_hat_1.name
        expect(response.body).to include product_hat_1.price.to_s
        expect(response.body).to include(product_hat_1.display_image.attachment(:small))
      end
    end
  end
end
