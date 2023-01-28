require 'rails_helper'

RSpec.describe "categories_page", type: :system do
  describe "カテゴリーページ" do

    let!(:taxonomy_categories) { create(:taxonomy, name: "Categories") }
    let!(:taxonomy_brand) { create(:taxonomy) }
    let!(:taxon_jackets) { create(:taxon, name: "jackets", taxonomy: taxonomy_categories, parent_id: taxonomy_categories.taxons.first.id) }
    let!(:taxon_HTML) { create(:taxon, name: "HTML", taxonomy: taxonomy_brand, parent_id: taxonomy_brand.taxons.first.id) }
    let!(:product) { create(:product, name: "potepan-jackets", taxons: [taxon_jackets]) }
    let!(:image) { create(:image) }

    before do
      product.images << image
      visit potepan_category_path(taxon_jackets.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = page.current_host
      product.reload
      image.reload
    end

    it "titleにtaxon.nameが表示されること" do
      expect(page).to have_title "#{taxon_jackets.name} - BIGBAG Store"
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

    it "taxonのnameが表示されること" do
      within ".page-title" do
        expect(page).to have_content taxon_jackets.name
      end
      within ".breadcrumb" do
        expect(page).to have_content taxon_jackets.name
      end
    end

    it "商品カテゴリー欄にtaxonのrootの名前とleavesの名前が表示されること" do
      within ".side-nav" do
        expect(page).to have_content taxon_jackets.root.name
        expect(page).to have_content taxon_jackets.name
        expect(page).to have_content taxon_HTML.root.name
        expect(page).to have_content taxon_HTML.name
      end
    end

    it '商品カテゴリー欄の各カテゴリーとブランドのリンクからそのカテゴリーページへ遷移すること' do
      within '.side-nav' do
        click_on("#{taxon_HTML.name}")
        expect(current_path).to eq potepan_category_path(taxon_HTML.id)
      end
    end

    it "各カテゴリーとブランドに紐づく商品の画像・商品名・価格が表示されること" do
      within ".productBox" do
        expect(page).to have_selector "img[alt='#{product.id}']"
        expect(page).to have_content product.name
        expect(page).to have_content product.display_price
      end
    end

    # 商品のリンクをクリックして、その商品詳細ページへ遷移すること
    it "商品のリンクをクリックして、その商品詳細ページへ遷移すること" do
      within ".productBox" do
        click_on("#{product.name}")
        expect(current_path).to eq potepan_product_path(product.id)
      end
    end

    # 【商品詳細ページのテストへ転記要】
    # 「一覧ページへ戻る」リンクをクリックして、その商品が属するカテゴリーページへ遷移すること

  end
end
