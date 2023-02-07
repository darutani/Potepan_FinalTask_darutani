require 'rails_helper'

RSpec.describe "products_page", type: :system do
  describe "商品詳細ページのメイン部分(.singleproduct部分)" do
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

  describe "商品詳細ページの関連商品欄(.productsContent部分)" do
    let(:taxon_jacket) { create(:taxon) }
    let(:taxon_hat) { create(:taxon) }
    let(:taxon_html) { create(:taxon) }
    let(:taxon_css) { create(:taxon) }
    let(:product_jacket_1) { create(:product, taxons: [taxon_jacket, taxon_html]) }
    let(:product_jacket_2) { create(:product, price: "20.99", taxons: [taxon_jacket, taxon_css]) }
    let(:product_hat_1) { create(:product, price: "30.99", taxons: [taxon_hat, taxon_html]) }
    let(:product_hat_2) { create(:product, price: "40.99", taxons: [taxon_hat, taxon_css]) }
    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }
    let(:image_3) { create(:image) }
    let(:image_4) { create(:image) }

    before do
      product_jacket_1.images << image_1
      product_jacket_2.images << image_2
      product_hat_1.images << image_3
      product_hat_2.images << image_4
      visit potepan_product_path(product_jacket_1.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = page.current_host
    end

    it "表示されている商品と同じカテゴリー・ブランドの全商品の商品名・価格・画像が表示されていること" do
      within ".productsContent" do
        expect(page).to have_content product_jacket_2.name
        expect(page).to have_content product_jacket_2.display_price
        expect(page).to have_selector "img[alt='products-img-#{product_jacket_2.id}']"
        expect(page).to have_content product_hat_1.name
        expect(page).to have_content product_hat_1.display_price
        expect(page).to have_selector "img[alt='products-img-#{product_hat_1.id}']"
      end
    end

    it "表示されている商品とカテゴリー・ブランド両方とも異なる商品の商品名・価格・画像が表示されていないこと" do
      within ".productsContent" do
        expect(page).to have_no_content product_hat_2.name
        expect(page).to have_no_content product_hat_2.display_price
        expect(page).to have_no_selector "img[alt='products-img-#{product_hat_2.id}']"
      end
    end

    it "関連商品のリンクをクリックして、その商品詳細ページへ遷移すること" do
      within ".productsContent" do
        click_on(product_jacket_2.name)
        expect(current_path).to eq potepan_product_path(product_jacket_2.id)
      end
    end
  end
end
