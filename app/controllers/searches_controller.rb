class SearchesController < ApplicationController

  skip_authorization_check

  def index
    search_query = clear_specialize_symbols(params[:search])
    redirect_to questions_path, alert: 'Поле не может быть пустым' if search_query.empty?
    @data = category.search(search_query, page: params[:page], per_page: 3)
  end

  private

  def category
    if params[:category] == 'Global_Search'
      ThinkingSphinx
    else
      Object.const_get(params[:category]) if Object.const_get(params[:category])
    end
  end

  def clear_specialize_symbols(search_query)
    search_query.gsub(/@/, '*')
  end
end
