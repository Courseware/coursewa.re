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
    its(:to) { should eq(["help@#{Courseware.config.domain_name}"]) }
    its('body.encoded') { should match(params[:message]) }
  end

  describe '#contact_email' do
    subject { GenericMailer.contact_email(params) }

    its(:subject) { should match(params[:name]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its(:to) { should eq(["hello@#{Courseware.config.domain_name}"]) }
    its('body.encoded') { should match(params[:message]) }
    its('body.encoded') { should match(params[:email]) }
    its('body.encoded') { should match(params[:remote_ip]) }
  end

end
