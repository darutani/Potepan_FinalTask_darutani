require 'rails_helper'

RSpec.describe "categories_page", type: :system do
  describe "カテゴリーページ" do
    let(:taxon_jacket) do
      create(:taxon, name: "jackets", taxonomy: taxonomy_category, parent_id: taxonomy_category.root.id)
    end
    let!(:taxon_html) do
      create(:taxon, name: "HTML", taxonomy: taxonomy_brand, parent_id: taxonomy_brand.root.id)
    end
    let(:taxonomy_category) { create(:taxonomy, name: "Categories") }
    let(:taxonomy_brand) { create(:taxonomy) }
    let(:product_jacket) { create(:product, name: "potepan-jacket", taxons: [taxon_jacket]) }
    let(:product_bag) { create(:product, name: "potepan-bag") }
    let(:image) { create(:image) }

    before do
      product_jacket.images << image
      visit potepan_category_path(taxon_jacket.id)

      # 画像URLの取得が上手くいかない問題への対応
      # https://mng-camp.potepan.com/curriculums/document-for-final-task-2#notes-of-image-test
      ActiveStorage::Current.host = page.current_host
      product_jacket.reload
      image.reload
    end

    it "titleにtaxon.nameが表示されること" do
      expect(page).to have_title "#{taxon_jacket.name} - BIGBAG Store"
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
        expect(page).to have_content taxon_jacket.name
      end
      within ".breadcrumb" do
        expect(page).to have_content taxon_jacket.name
      end
    end

    it "商品カテゴリー欄にtaxonのrootの名前とleavesの名前が表示されること" do
      within ".side-nav" do
        expect(page).to have_content taxon_jacket.root.name
        expect(page).to have_content taxon_jacket.name
        expect(page).to have_content taxon_html.root.name
        expect(page).to have_content taxon_html.name
      end
    end

    it '商品カテゴリー欄の各カテゴリーとブランドのリンクからそのカテゴリーページへ遷移すること' do
      within '.side-nav' do
        click_on(taxon_html.name)
        expect(current_path).to eq potepan_category_path(taxon_html.id)
      end
    end

    it "各カテゴリーとブランドに紐づく商品の画像・商品名・価格が表示されること" do
      within ".productBox" do
        expect(page).to have_selector "img[alt='#{product_jacket.id}']"
        expect(page).to have_content product_jacket.name
        expect(page).to have_content product_jacket.display_price
      end
    end

    it "商品のリンクをクリックして、その商品詳細ページへ遷移すること" do
      within ".productBox" do
        click_on(product_jacket.name)
        expect(current_path).to eq potepan_product_path(product_jacket.id)
      end
    end

    it "taxonに紐づいていないproduct_bagの商品名が表示されないこと" do
      within ".productBox" do
        expect(page).to have_no_content product_bag.name
      end
    end
  end
end
