require 'spec_helper'

describe Coursewareable::CollaborationsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:collaboration) do
    Fabricate('coursewareable/collaboration', :classroom => classroom)
  end

  describe 'DELETE :destroy' do
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => collaboration.id,
             :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end
