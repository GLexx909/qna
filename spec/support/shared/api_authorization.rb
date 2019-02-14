shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'return 401 status if there is no access_token' do
      do_request(methods, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'return 401 status if access_token is invalid' do
      do_request(methods, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Request Success' do
  it 'returns 200 status code' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Returns list of object' do
  it 'returns list of object' do
    expect(json_object.size).to eq 2
  end
end

shared_examples_for 'Returns all public fields' do
  it 'returns all public fields' do
    fields.each do |attr|
      expect(object_response[attr]).to eq object.send(attr).as_json
    end
  end
end

shared_examples_for 'Returns links' do
  let(:link) { links.first }
  let(:links_response) { object_response['links'].last }

  it 'returns list of links' do
    expect(object_response['links'].size).to eq 3
  end

  it 'returns all public fields' do
    %w[id name url linkable_type linkable_id].each do |attr|
      expect(links_response[attr]).to eq link.send(attr).as_json
    end
  end
end

shared_examples_for 'Authorized' do
  it 'returns 200 status' do
    post api_path, params: { access_token: access_token.token, object => attributes_for(object.to_sym) }
    expect(response).to be_successful
  end
end

shared_examples_for 'To update object' do
  it 'the object' do
    object.reload
    if object.class == Question
      expect(object.title).to eq 'Title_new'
      expect(object.body).to eq 'Body_new'
    elsif object.class == Answer
      expect(object.body).to eq 'Body_new'
    end
  end
end

shared_examples_for 'To delete object' do
  context 'if authorized' do
    it 'returns 200 status' do
      delete api_path, params: { access_token: access_token.token }
      expect(response).to be_successful
    end

    it 'delete the object' do
      expect { delete api_path, params: { access_token: access_token.token } }.to change(object, :count).by(-1)
    end
  end
end
