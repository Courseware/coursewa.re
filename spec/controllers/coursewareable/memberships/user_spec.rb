require 'spec_helper'

describe Coursewareable::MembershipsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:user) { Fabricate(:confirmed_user) }
  let(:membership) do
    Fabricate('coursewareable/membership', :classroom => classroom)
  end

  describe 'DELETE :destroy' do
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => membership.id,
             :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it { should redirect_to(login_path) }
    end
  end

end

