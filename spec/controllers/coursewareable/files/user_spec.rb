require 'spec_helper'

describe Coursewareable::FilesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET index' do
    before do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE destroy' do
    let(:upload) { Fabricate('coursewareable/upload', :classroom => classroom,
                            :user => classroom.owner) }
    before do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => upload.id, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

end
