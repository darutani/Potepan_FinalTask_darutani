require 'rails_helper'

RSpec.describe Potepan::ProductDecorator, type: :model do
  describe "#related_products" do
    let!(:taxon_1) { create(:taxon) }
    let!(:taxon_2) { create(:taxon) }
    let!(:taxon_3) { create(:taxon) }
    let!(:product_1) { create(:product, taxons: [taxon_1, taxon_3]) }
    let!(:product_2) { create(:product, taxons: [taxon_1, taxon_3]) }
    let!(:product_3) { create(:product, taxons: [taxon_2, taxon_3]) }

    it "同じTaxonに属する商品をもれなく取得すること" do
      expect(product_1.related_products).to include product_2, product_3
    end

    it "メソッドを呼び出した商品オブジェクト(レシーバー)自体を含まないこと" do
      expect(product_1.related_products).not_to include product_1
    end

    it "商品オブジェクトが重複しないこと" do
      expect(product_1.related_products).to eq product_1.related_products.distinct
    end
  end
end
