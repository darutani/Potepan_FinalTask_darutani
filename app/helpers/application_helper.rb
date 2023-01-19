module ApplicationHelper
  # ページ毎のtitle表示
  BASE_TITLE = "BIGBAG Store".freeze
  def page_title(page_title)
    if page_title.empty?
      BASE_TITLE
    else
      page_title + " - " + BASE_TITLE
    end
  end
end
