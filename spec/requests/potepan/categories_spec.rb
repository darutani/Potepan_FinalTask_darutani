require 'rails_helper'

RSpec.describe "Potepna::Categories", type: :request do
  describe "GET /show" do
    let(:taxon_jackets) do
      create(:taxon, name: "jackets", taxonomy: taxonomy_categories, parent_id: taxonomy_categories.taxons.first.id)
    end
    let(:taxonomy_categories) { create(:taxonomy, name: "Categories") }
    let(:product) { create(:product, name: "potepan-jackets", taxons: [taxon_jackets]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      get potepan_category_path(taxon_jackets.id)

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
      expect(response.body).to include "#{taxon_jackets.name} - BIGBAG Store"
      expect(response.body).to include taxon_jackets.name
      expect(response.body).to include taxon_jackets.root.name
      expect(response.body).to include product.name
      expect(response.body).to include product.display_price.to_s
      expect(response.body).to include product.display_image.attachment(:small)
    end
  end
end
