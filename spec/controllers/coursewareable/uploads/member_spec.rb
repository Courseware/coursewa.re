require 'spec_helper'

describe Coursewareable::UploadsController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:membership) { Fabricate('coursewareable/membership',
                                  :classroom => classroom) }
  let(:member) { membership.user }

  describe 'POST create' do

    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => member, :classroom => classroom) }

    context 'being logged in as member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
        post :create, { :use_route => :coursewareable,
          :file => fixture_file_upload('/test.txt', 'text/plain'),
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
    let(:upload) { Fabricate('coursewareable/upload', :classroom => classroom,
                            :user => classroom.owner) }
    before(:each) do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => upload.id)
    end

    context 'being logged in as member' do

      it do
        should redirect_to(login_path)
        classroom.uploads.should_not be_empty
      end

      context 'upload is missing' do
        before(:all) { upload.destroy }

        it { redirect_to(login_path) }
      end
    end
  end

end
