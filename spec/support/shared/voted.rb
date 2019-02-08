shared_examples_for "voted" do
  describe 'POST #vote_up' do
    context 'not author can vote' do
      before { login(user2) }

      it 'create vote' do
        expect { post :vote_up, params: { id: votable }, format: :json }.to change(Vote, :count).by 1
      end
    end

    context 'author can not vote' do
      before { login(user) }

      it 'status 403' do
        post :vote_down, params: { id: votable }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'POST #vote_down' do
    context 'not author can vote' do
      before { login(user2) }

      it 'create vote' do
        expect { post :vote_up, params: { id: votable }, format: :json }.to change(Vote, :count).by 1
      end
    end

    context 'author can not vote' do
      before { login(user) }

      it 'status 403' do
        patch :vote_down, params: { id: votable }, format: :json
        expect(response).to have_http_status 403
      end
    end
  end
end
