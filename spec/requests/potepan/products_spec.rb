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
    let(:taxon) { create(:taxon) }
    let(:product) { create(:product, taxons: [taxon]) }
    # rubocop:disable Style/BlockDelimiters
    let(:related_products) {
      create_list(:product, 5, taxons: [taxon]) do |product, i|
        product.price = i
        product.save
      end
    }
    # rubocop:enable Style/BlockDelimiters
    let(:image) { create(:image) }

    before do
      product.images << image
      related_products.each do |related_product|
        related_product.images << create(:image)
      end
      get potepan_product_path(product.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = request.base_url
    end

    it "関連商品の正しい商品情報が取得できていること" do
      related_products.first(4).each do |related_product|
        expect(response.body).to include related_product.name
        expect(response.body).to include related_product.display_price.to_s
        expect(response.body).to include related_product.display_image.attachment(:small)
      end
    end

    it "５つ目の関連商品が表示されていないこと（関連商品の表示が最大４つであること）" do
      expect(response.body).not_to include related_products.last.name
      expect(response.body).not_to include related_products.last.display_image.attachment(:small)
    end
  end
end
