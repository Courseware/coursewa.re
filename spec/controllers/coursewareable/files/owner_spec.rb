require 'spec_helper'

describe Coursewareable::FilesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET index' do
    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:index) }
    end
  end

  describe 'DELETE destroy' do
    let(:upload) { Fabricate('coursewareable/upload', :classroom => classroom,
                            :user => classroom.owner) }
    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => upload.id)
    end

    context 'being logged in as owner' do
      it { should redirect_to(files_path) }

      context 'upload is missing' do
        before(:all) { upload.destroy }

        it { should redirect_to('/404') }
      end
    end
  end

end
