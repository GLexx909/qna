class My::BadgesController < ApplicationController

  def index
    @answers = current_user.best_answers
  end
end
