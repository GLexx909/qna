class SearchesController < ApplicationController

  authorize_resource class: Services::SearchSphinxService

  def index
    @data = Services::SearchSphinxService.new.find(params[:category], params[:search], params[:page])
    redirect_to questions_path, alert: 'Поле не может быть пустым' if !@data
  end
end
