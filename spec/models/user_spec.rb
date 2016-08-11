RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  context 'relationships' do
    it { expect(user).to have_many(:organizations) }
  end

  context 'validations' do
    it { expect(user).to validate_presence_of(:email) }

    it { expect(user).to validate_length_of(:email).is_at_most(255) }
    it { expect(user).to validate_length_of(:password).is_at_most(72) }
  end

  context 'callbacks' do
    it { expect(user).to callback(:init_organization).after(:create) }
    it { expect(user).to callback(:send_new_user_instructions).after(:create) }
    it { expect(user).to callback(:can_delete?).before(:destroy) }
  end

  context '.methods' do
    it { expect(user.confirm!).to be_truthy }
    it { expect(user.send_reset_password_instructions).to be_truthy }
    it { expect(user.change_email! 'test@test.org').to be_truthy }

    context 'can update password' do
      context 'with valid password' do
        it { expect(user.can_update_password '00000000').to be_truthy }
      end

      context 'with invalid password' do
        it { expect(user.can_update_password 'xxxxxxxx').to be_falsey }
      end
    end
  end

  context 'can delete?' do
    it { expect(user.can_delete?).to be_falsey }
  end

  context 'json' do
    it { expect(JSON.parse(user.to_json)).to eq(JSON.parse(user.as_json.to_json)) }
  end
end
