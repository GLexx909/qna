class My::BadgesController < ApplicationController

  def index
    @answers = current_user.answers.best
  end
end
