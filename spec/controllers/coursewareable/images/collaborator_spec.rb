require 'spec_helper'

describe Coursewareable::ImagesController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:collaboration) { Fabricate('coursewareable/collaboration',
                                  :classroom => classroom) }
  let(:collaborator) { collaboration.user }

  describe 'GET index' do

    context 'being logged in as collaborator' do
      before(:each) do
        @controller.send(:auto_login, collaborator)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:index, :use_route => :coursewareable, :format => :json)
      end

      subject { JSON.parse(response.body) }

      its(:size) { should eq(0) }

      context 'with some images' do
        before(:all) do
          @image = Fabricate('coursewareable/image', :classroom => classroom)
        end

        it do
          subject.size.should eq(1)
          subject.first['image'].should eq(@image.url(:large))
        end
      end
    end

  end

  describe 'POST create' do

    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => collaborator, :classroom => classroom) }

    context 'being logged in as collaborator' do
      before(:each) do
        @controller.send(:auto_login, collaborator)
        @request.host = "#{classroom.slug}.#{@request.host}"
        post :create, { :use_route => :coursewareable,
          :file => fixture_file_upload('/test.png', 'image/png'),
          :assetable_type => syllabus.class.name,
          :assetable_id => syllabus.id
        }
      end

      subject { JSON.parse(response.body) }

      its('first.last') { should eq(classroom.images.first.url(:large)) }

      context 'and assetable object is missing' do
        let(:syllabus) { classroom.build_syllabus }

        its(:keys) { should include('error') }
      end

      context 'with file uploads limits reached' do
        before(:all) do
          collaborator.plan.decrement(:allowed_space, 1.gigabyte)
        end

        its(:keys) { should include('error') }
      end
    end

  end

  describe 'DELETE :destroy' do
    let(:image) { Fabricate('coursewareable/image', :classroom => classroom,
                            :user => classroom.owner) }
    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => image.id)
    end

    context 'being logged in as collaborator' do

      it do
        should redirect_to(images_url)
        classroom.images.should be_empty
      end

      context 'image is missing' do
        before(:all) { image.destroy }

        it { should redirect_to('/404') }
      end
    end
  end

end
