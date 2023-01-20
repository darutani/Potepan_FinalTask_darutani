module ApplicationHelper
  # ページ毎のtitle表示
  BASE_TITLE = "BIGBAG Store".freeze
  def page_title(page_title)
    page_title.blank? ? BASE_TITLE : "#{page_title} - #{BASE_TITLE}"
  end
end
