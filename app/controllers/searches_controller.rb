class SearchesController < ApplicationController

  skip_authorization_check

  def index
    search_query = clear_specialize_symbols(params[:search])
    redirect_to questions_path, alert: 'Поле не может быть пустым' if search_query.empty?
    @data = Services::SearchSphinxService.new.find(params[:category], search_query, params[:page])
  end

  private

  def clear_specialize_symbols(search_query)
    search_query.gsub(/@/, '*')
  end
end
