require 'rails_helper'

RSpec.describe AnswerNewNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, author: user, question: question) }
  let(:service) { double('Service::NewsNotification') }

  before do
    allow(Services::NewsNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewsNotification#send_question_updates' do
    expect(service).to receive(:send_question_updates).with(answer)
    AnswerNewNotificationJob.perform_now(answer)
  end
end
