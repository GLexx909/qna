class Services::SearchSphinxService
  def find(category_query, search_query, page)
    return false if clear_specialize_symbols(search_query).empty?
    category(category_query).search(search_query, page: page, per_page: 10)
  end

  private

  def category(category_query)
    return ThinkingSphinx if category_query == 'Global_Search'
    category_query.constantize if category_query.constantize
  end

  def clear_specialize_symbols(search_query)
    search_query.gsub(/@/, '*')
  end
end
