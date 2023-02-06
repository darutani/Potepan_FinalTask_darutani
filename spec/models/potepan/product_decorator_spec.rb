require 'rails_helper'

RSpec.describe Potepan::ProductDecorator, type: :model do
  describe "#related_products" do
    let!(:taxon_jacket) { create(:taxon, name: "jackets") }
    let!(:taxon_hat) { create(:taxon, name: "hats") }
    let!(:taxon_html) { create(:taxon, name: "HTML") }
    let!(:product_jacket_1) { create(:product, name: "potepan-jacket-1", taxons: [taxon_jacket, taxon_html]) }
    let!(:product_jacket_2) { create(:product, name: "potepan-jacket-2", taxons: [taxon_jacket, taxon_html]) }
    let!(:product_hat_1) { create(:product, name: "potepan-hat-1", taxons: [taxon_hat, taxon_html]) }

    it "同じTaxonに属する商品をもれなく取得すること" do
      expect(product_jacket_1.related_products).to include product_jacket_2, product_hat_1
    end

    it "メソッドを呼び出した商品オブジェクト(レシーバー)自体を含まないこと" do
      expect(product_jacket_1.related_products).not_to include product_jacket_1
    end

    it "商品オブジェクトが重複しないこと" do
      expect(product_jacket_1.related_products).to eq product_jacket_1.related_products.distinct
    end
  end
end
