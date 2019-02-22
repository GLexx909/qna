class Services::SearchSphinxService
  CATEGORY = %w(Global_Search User Question Answer Comment) # Coordinate it with view helper: resources_helper.rb

  def find(category_query, search_query, page)
    if access_open(category_query, search_query)
      category(category_query).search(escape(search_query), page: page, per_page: 10)
    end
  end

  private

  def category(category_query)
    category_query == 'Global_Search' ? ThinkingSphinx : category_query.constantize
  end

  def escape(search_query)
    ThinkingSphinx::Query.escape(search_query)
  end

  def access_open(category_query, search_query)
    CATEGORY.include?(category_query) && search_query.present?
  end
end
