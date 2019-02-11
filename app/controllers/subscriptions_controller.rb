class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def swap
    if subscription
      subscription.destroy
      @question = question
      @color_class = ''
    else
      subscription_create
      @question = question
      @color_class = 'orange600'
    end
  end

  private

  def subscription
    current_user.subscriptions.find_by(question: question)
  end

  def question
    Question.find(params[:id])
  end

  def subscription_create
    subscription = current_user.subscriptions.new(question: question)
    subscription.save
  end
end
