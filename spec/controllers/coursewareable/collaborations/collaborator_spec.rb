require 'spec_helper'

describe Coursewareable::CollaborationsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:collaborator) { Fabricate(:confirmed_user) }
  let(:collaboration) do
    Fabricate('coursewareable/collaboration', :classroom => classroom)
  end

  describe 'DELETE :destroy' do
    before(:each) do
      classroom.collaborators << collaborator

      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => collaboration.id,
             :use_route => :coursewareable)
    end

    context 'being logged in as collaborator' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, collaborator)
      end

      it { should redirect_to(login_path) }

      context 'collaboration already destroyed' do
        before { collaboration.destroy }

        it { should redirect_to(login_path) }
      end

    end
  end

end
