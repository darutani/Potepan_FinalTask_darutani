module ApplicationHelper
  # ページ毎のtitle表示
  def page_title(page_title)
    base_title = "BIGBAG Store"

    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end
end
