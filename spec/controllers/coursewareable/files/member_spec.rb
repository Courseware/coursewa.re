require 'spec_helper'

describe Coursewareable::FilesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:membership) { Fabricate('coursewareable/membership',
                                  :classroom => classroom) }
  let(:member) { membership.user }

  describe 'GET index' do
    let(:upload) { Fabricate('coursewareable/upload', :classroom => classroom,
                            :user => classroom.owner) }
    before(:each) do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'being logged in as member' do
      it { should render_template(:index) }
    end
  end

  describe 'DELETE destroy' do
    let(:upload) { Fabricate('coursewareable/upload', :classroom => classroom,
                            :user => member) }

    before(:each) do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => upload.id)
    end

    context 'being logged in as member' do
      it { should redirect_to(files_path) }

      context 'redirects if file is not owned' do
        let(:upload) do
          Fabricate('coursewareable/upload', :classroom => classroom,
                    :user => classroom.owner)
        end

        it { should redirect_to(login_path) }
      end
    end
  end

end
