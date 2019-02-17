class Services::SearchSphinxService
  def find(category_query, search_query, page)
    category(category_query).search(search_query, page: page, per_page: 10)
  end

  private

  def category(category_query)
    if category_query == 'Global_Search'
      ThinkingSphinx
    else
      category_query.constantize if category_query.constantize
    end
  end
end
