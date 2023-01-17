require 'rails_helper'

RSpec.describe "products_page", type: :system do
  describe "課題提出フォーム" do
    let!(:product) { create(:product) }
    let!(:image) { create(:image) }

    before do
      product.images << image
      visit potepan_product_path(product.id)
      get potepan_product_path(product.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = page.current_host
      product.reload
      image.reload
    end

    # BIGBAGアイコンをクリックして、indexページへ遷移
    it "BIGBAGアイコンをクリックしてindexページへ遷移すること" do
      click_on('logo')
      expect(current_path).to eq potepan_products_path
    end

    # 商品名を表示
    it "商品名が表示されること" do
      within ".page-title" do
        expect(page).to have_content product.name
      end
      within ".breadcrumb" do
        expect(page).to have_content product.name
      end
      within ".media-body" do
        expect(page).to have_content product.name
      end
    end

    # 商品価格を表示
    it "商品価格が表示されること" do
      within ".media-body" do
        expect(page).to have_content product.display_price
      end
    end

    # 商品画像を表示
    it "商品画像が表示されていること" do
      within ".media" do
        product.images.each { |image| expect(response.body).to include(image.attachment(:large)) }
        product.images.each { |image| expect(response.body).to include(image.attachment(:small)) }
      end
    end
  end
end
