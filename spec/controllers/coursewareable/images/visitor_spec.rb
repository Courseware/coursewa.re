require 'spec_helper'

describe Coursewareable::ImagesController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET index' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:syllabus) { Fabricate('coursewareable/syllabus',
                       :user => classroom.owner, :classroom => classroom) }
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, { :use_route => :coursewareable,
                      :file => fixture_file_upload('/test.png', 'image/png'),
                      :assetable_type => syllabus.class.name,
                      :assetable_id => syllabus.id } )
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE :destroy' do
    let(:image) { Fabricate('coursewareable/image', :classroom => classroom,
                            :user => classroom.owner) }
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => image.id, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end
