require 'spec_helper'
require 'ostruct'

describe Subdomains::Allowed do
  let(:request) { OpenStruct.new(:subdomain => nil) }

  subject { Subdomains::Allowed.matches?(request) }

  Courseware.config.domain_blacklist.each do |domain|
    context "for #{domain}" do
      before { request.subdomain = domain }
      it { should be_true}
    end
  end

  context 'and a random domain name' do
    before { request.subdomain = Faker::Internet.domain_word }
    it { should be_false}
  end
end

describe Subdomains::Forbidden do
  let(:request) { OpenStruct.new(:subdomain => nil) }

  subject { Subdomains::Forbidden.matches?(request) }

  Courseware.config.domain_blacklist.each do |domain|
    context "for #{domain}" do
      before { request.subdomain = domain }
      it { should be_false}
    end
  end

  context 'and a random domain name' do
    before { request.subdomain = Faker::Internet.domain_word }
    it { should be_true}
  end
end
