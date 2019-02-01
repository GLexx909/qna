class My::BadgesController < ApplicationController

  authorize_resource

  def index
    @answers = current_user.answers.best
  end
end
