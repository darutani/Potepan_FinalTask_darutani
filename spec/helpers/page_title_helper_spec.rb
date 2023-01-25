require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "page_title" do
    it "正しいtitleを取得できていること" do
      expect(helper.page_title(nil)).to eq("BIGBAG Store")
      expect(helper.page_title("")).to eq("BIGBAG Store")
      expect(helper.page_title("page_title")).to eq("page_title - BIGBAG Store")
    end
  end
end
