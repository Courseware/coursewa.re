require 'spec_helper'

describe Coursewareable::MembershipsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:membership) do
    Fabricate('coursewareable/membership', :classroom => classroom)
  end

  describe 'DELETE :destroy' do
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => membership.id,
             :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, classroom.owner)
      end

      it { should redirect_to(edit_classroom_path) }

      context 'collaboration already destroyed' do
        before { membership.destroy }

        it { should redirect_to('/404') }
      end

    end
  end

end
