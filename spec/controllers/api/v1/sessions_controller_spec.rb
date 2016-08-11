describe Api::V1::SessionsController, type: :controller do
  it 'DELETE /api/v1/sessions' do
    user = FactoryGirl.create(:user)
    request.session[:user_id] = user.id

    delete :destroy

    expect(response.status).to eq(204)
    expect(response).to be_success
  end
end
