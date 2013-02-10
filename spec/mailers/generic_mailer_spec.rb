require 'spec_helper'

describe GenericMailer do
  let(:params) do
    {:name => Faker::Name.name, :email => Faker::Internet.email,
     :message => Faker::Lorem.paragraph, :remote_ip => '8.8.8.8'}
  end

  describe '#support_email' do
    subject { GenericMailer.support_email(params) }

    its(:subject) { should match(params[:name]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its(:reply_to) { should eq([Courseware.config.support_email_address]) }
    its(:to) { should eq(["help@#{Courseware.config.domain_name}"]) }
    its('body.encoded') { should match(params[:message]) }
  end

  describe '#contact_email' do
    subject { GenericMailer.contact_email(params) }

    its(:subject) { should match(params[:name]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its(:reply_to) { should eq([Courseware.config.support_email_address]) }
    its(:to) { should eq(["hello@#{Courseware.config.domain_name}"]) }
    its('body.encoded') { should match(params[:message]) }
    its('body.encoded') { should match(params[:email]) }
    its('body.encoded') { should match(params[:remote_ip]) }
  end

  describe '#invitation_email' do
    let(:user) { Fabricate(:confirmed_user) }
    subject { GenericMailer.invitation_email(user, params) }

    its(:subject) { should match(user.name) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its(:reply_to) { should eq([user.email]) }
    its(:to) { should eq([params[:email]]) }
    its('body.encoded') { should match(params[:message]) }
  end

  describe '#survey_email' do
    let(:new_params) do
      params[:category] = 'ui_ux'
      params[:current_path] = 'some_path'
      params
    end
    subject { GenericMailer.survey_email(params) }

    its(:subject) { should match(new_params[:name]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its(:reply_to) { should eq([Courseware.config.support_email_address]) }
    its(:to) { should eq(
      ["help+#{new_params[:category]}@#{Courseware.config.domain_name}"]) }
    its('body.encoded') { should match(new_params[:message]) }
    its('body.encoded') { should match(new_params[:current_path]) }
  end

end
