describe Api::V1::RegistrationsController, type: :controller do
  context 'POST /api/vi/registrations' do
    payload = {
      user: {
        email: 'new-user@test.org',
        password: '000000000'
      }
    }

    it 'with unused email' do
      post :create, payload

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).to_json).to be_json_eql({ success: true }.to_json)
    end

    it 'with already used email' do
      post :create, payload
      expect(response.status).to eq(200)

      post :create, payload
      expect(response.status).to eq(422)
    end
  end

  it 'GET /api/v1/registrations' do
    user = FactoryGirl.create(:user)
    request.session[:user_id] = user.id

    get :show

    expect(response.status).to eq(200)
    expect(JSON.parse(response.body).to_json).to be_json_eql({
      email: user.email,
      confirmed: false,
      permissions: {
        delete: false
      }
    }.to_json)
  end

  context 'PATCH /api/v1/registration/1' do
    it 'with valid information' do
      user = FactoryGirl.create(:user)
      request.session[:user_id] = user.id

      patch :update, user: { first_name: 'Updated' }

      expect(response.status).to eq(200)
    end

    it 'with password' do
      user = FactoryGirl.create(:user)
      request.session[:user_id] = user.id

      patch :update, user: { first_name: 'Updated', current_password: '0000' }

      expect(response.status).to eq(200)
    end

    it 'with invalid information' do
      user = FactoryGirl.create(:user)
      request.session[:user_id] = user.id

      patch :update, user: { email: '' }

      expect(response.status).to eq(422)
    end
  end
end
