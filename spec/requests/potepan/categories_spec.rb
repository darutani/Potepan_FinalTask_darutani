require 'rails_helper'

RSpec.describe "Potepna::Categories", type: :request do
  describe "GET /show" do
    let(:taxon_jacket) do
      create(:taxon, name: "jacket", taxonomy: taxonomy_category, parent_id: taxonomy_category.root.id)
    end
    let(:taxonomy_category) { create(:taxonomy, name: "Categories") }
    let(:product) { create(:product, name: "potepan-jacket", taxons: [taxon_jacket]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get potepan_category_path(taxon_jacket.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = request.base_url
      product.reload
      image.reload
    end

    it "正しいHTTPレスポンスを返すこと" do
      expect(response).to have_http_status(:success)
    end

    it "正しいカテゴリー情報が取得できていること" do
      expect(response.body).to include "#{taxon_jacket.name} - BIGBAG Store"
      expect(response.body).to include taxon_jacket.name
      expect(response.body).to include taxon_jacket.root.name
    end

    it "正しい商品情報が取得できていること" do
      expect(response.body).to include product.name
      expect(response.body).to include product.display_price.to_s
      expect(response.body).to include product.display_image.attachment(:small)
    end
  end
end
