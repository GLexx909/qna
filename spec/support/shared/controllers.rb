shared_examples_for 'To save a new object' do
  it 'saves a new object in the database' do
    expect { post :create, params: params, format: :js }.to change(object_class, :count).by(1)
  end

  it 'according to the author of the object' do
    post :create, params: params, format: :js
    expect(assigns(object.to_sym).author).to eq user
  end
end

shared_examples_for 'To create now object' do
  it 'should create new subscription' do
    expect { post methods, params: params, format: :js }.to change(object, :count).by(1)
  end
end

shared_examples_for 'To does not save a new object' do
  it 'does not save a new object' do
    expect { post :create, params: params, format: :js }.to_not change(object_class, :count)
  end
end

shared_examples_for 'To update the object' do
  it 'update the object in the database' do
    patch :update, params: params.merge({id: object.id }), format: :js
    expect(assigns(object.class.to_s.downcase.to_sym)).to eq object
  end
end

shared_examples_for 'To change the object attributes' do
  it 'change the object attributes' do
    patch :update, params: params.merge({id: object.id }), format: :js
    object.reload

    expect(object.title).to eq 'new_title' if object.respond_to?(:title)
    expect(object.body).to eq 'new_body'
  end

  it 'render update view' do
    patch :update, params: params.merge({id: object.id }), format: :js
    expect(response).to render_template :update
  end
end

shared_examples_for 'To not change the object attributes' do
  before { patch :update, params: params.merge({id: object.id }), format: :js }

  it 'does not change object' do
    object.reload
    expect(object.title).to eq 'MyTitle' if object.respond_to?(:title)
    expect(object.body).to eq 'MyBody'
  end
end

shared_examples_for 'To render update view' do
  it 'render update view' do
    patch :update, params: params.merge({id: object.id}), format: :js
    expect(response).to render_template :update
  end
end

shared_examples_for 'PATCH to render status 403' do
  it 'render status 403' do
    patch :update, params: params.merge({id: object.id}), format: :js
    expect(response).to have_http_status 403
  end
end

shared_examples_for 'To delete the object' do
  it 'deletes the object' do
    expect { delete :destroy, params: { id: object }, format: :js }.to change(object_class, :count).by(-1)
  end
end

shared_examples_for 'To not delete the object' do
  it 'deletes the object' do
    expect { delete :destroy, params: { id: object }, format: :js }.to_not change(object_class, :count)
  end
end

shared_examples_for 'DELETE to render status 403' do
  it 'render status 403' do
    delete :destroy, params: { id: object }, format: :js
    expect(response).to have_http_status 403
  end
end

shared_examples_for "To POST render view js" do
  #view must be symbol
  it "should render view js" do
    post view, params: params, format: :js
    expect(response).to render_template view
  end
end

shared_examples_for "To DELETE render view js" do
  #view must be symbol
  it "should render view js" do
    delete view, params: params, format: :js
    expect(response).to render_template view
  end
end
