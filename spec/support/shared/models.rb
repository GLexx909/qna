shared_examples_for 'Have many attached file' do
  it 'have many attached file' do
    expect(object_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
