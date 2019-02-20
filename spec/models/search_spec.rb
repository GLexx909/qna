require 'rails_helper'

RSpec.describe Services::SearchSphinxService do
  describe '.find' do
    it 'should return an array of all classes objects' do
      expect(ThinkingSphinx).to receive(:search).with('Test Search', page: 1, per_page: 10)
      subject.find('Global_Search', 'Test Search', 1)
    end

    %w(User Question Answer Comment).each do |klass|
      it "should return an array of #{klass} class objects" do
        expect(klass.constantize).to receive(:search).with('Test Search', page: 1, per_page: 10)
        subject.find(klass, 'Test Search', 1)
      end
    end

    it 'should return false if Search Query if blank' do
      expect(subject.find('Global_Search', '', 1)).to eq false
    end
  end
end
