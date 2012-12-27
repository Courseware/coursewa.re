require 'spec_helper'

describe Coursewareable::ImagesController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:membership) { Fabricate('coursewareable/membership',
                                  :classroom => classroom) }
  let(:member) { membership.user }

  describe 'GET index' do

    context 'being logged in as member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:index, :use_route => :coursewareable, :format => :json)
      end

      it { redirect_to(login_path) }
    end

  end

  describe 'POST create' do

    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => member, :classroom => classroom) }

    context 'being logged in as member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
        post :create, { :use_route => :coursewareable,
          :file => fixture_file_upload('/test.png', 'image/png'),
          :assetable_type => syllabus.class.name,
          :assetable_id => syllabus.id
        }
      end

      it { redirect_to(login_path) }

      context 'and assetable object is missing' do
        let(:syllabus) { classroom.build_syllabus }

        it { redirect_to(login_path) }
      end
    end

  end

  describe 'DELETE :destroy' do
    let(:image) { Fabricate('coursewareable/image', :classroom => classroom,
                            :user => classroom.owner) }
    before(:each) do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => image.id)
    end

    context 'being logged in as member' do

      it do
        should redirect_to(login_path)
        classroom.images.should_not be_empty
      end

      context 'image is missing' do
        before(:all) { image.destroy }

        it { redirect_to(login_path) }
      end
    end
  end

end
