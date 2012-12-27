require 'spec_helper'

describe Coursewareable::ImagesController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET index' do
    before do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable, :format => :json)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:syllabus) { Fabricate('coursewareable/syllabus',
                       :user => classroom.owner, :classroom => classroom) }
    before do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, { :use_route => :coursewareable,
                      :file => fixture_file_upload('/test.png', 'image/png'),
                      :assetable_type => syllabus.class.name,
                      :assetable_id => syllabus.id } )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE :destroy' do
    let(:image) { Fabricate('coursewareable/image', :classroom => classroom,
                            :user => classroom.owner) }
    before do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => image.id, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

end

