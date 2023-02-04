require 'rails_helper'

RSpec.describe "products_page", type: :system do
  describe "商品詳細ページ" do
    let(:taxon) { create(:taxon) }
    let(:product) { create(:product, taxons: [taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit potepan_product_path(product.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = page.current_host
      product.reload
      image.reload
    end

    it "titleに商品名が表示されること" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
    end

    it "BIGBAGアイコンをクリックしてhomeページへ遷移すること" do
      click_on('logo')
      expect(current_path).to eq potepan_path
    end

    it "navbarのHOMEをクリックしてhomeページへ遷移すること" do
      within ".navbar-right" do
        click_on('Home')
        expect(current_path).to eq potepan_path
      end
    end

    it "LightSecitonのHOMEをクリックしてhomeページへ遷移すること" do
      within ".breadcrumb" do
        click_on('Home')
        expect(current_path).to eq potepan_path
      end
    end

    it "「一覧ページへ戻る」リンクをクリックしてカテゴリーページへ遷移すること" do
      within ".list-page" do
        click_on('一覧ページへ戻る')
        expect(current_path).to eq potepan_category_path(product.taxons.first.id)
      end
    end

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

    it "商品価格が表示されること" do
      within ".media-body" do
        expect(page).to have_content product.display_price
      end
    end

    it "商品説明文が表示されること" do
      within ".media-body" do
        expect(page).to have_content product.description
      end
    end

    it "商品画像が表示されていること" do
      within ".media" do
        product.images.each { |image| expect(page).to have_selector "img[alt='#{image.id}']" }
      end
    end
  end
end
