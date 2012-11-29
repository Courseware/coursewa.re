require "spec_helper"

describe UserMailer do
  let(:user) { Fabricate('coursewareable/user') }

  describe 'activation_needed_email' do
    let(:mail) { UserMailer.activation_needed_email(user) }

    it 'should be valid' do
      mail.should have_subject('Welcome to Courseware')
      mail.should deliver_to(user.email)
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should have_body_text(activate_user_url(user.activation_token))
    end
  end

  describe 'activation_success_email' do
    let(:mail) { UserMailer.activation_success_email(user) }

    it 'should be valid' do
      mail.should have_subject('Your Courseware account was activated')
      mail.should deliver_to(user.email)
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should have_body_text(login_url)
    end
  end

  describe 'reset_password_email' do
    before do
      # Set a reset token
      token = Faker::HipsterIpsum.word
      user.update_attribute :reset_password_token, token
      user.update_attribute :reset_password_token_expires_at, Date.tomorrow
    end

    let(:mail) { UserMailer.reset_password_email(user) }

    it 'should be valid' do
      mail.should have_subject('Your Courseware password has been reset')
      mail.should deliver_to(user.email)
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should have_body_text(edit_password_url(user.reset_password_token))
    end
  end

end
