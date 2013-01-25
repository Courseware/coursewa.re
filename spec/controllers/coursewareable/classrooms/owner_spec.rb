require 'spec_helper'

describe Coursewareable::ClassroomsController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET dashboard' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:dashboard, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:dashboard) }
    end
  end

  describe 'GET new' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should redirect_to(login_path) }

      context 'with plan limits allowed to create a classroom' do
        before(:all) { classroom.owner.plan.increment!(:allowed_classrooms) }
        it { should render_template(:new) }
      end
    end
  end

  describe 'GET staff' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:staff, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:staff) }
    end
  end

  describe 'POST :create' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as owner' do
      it { should redirect_to(login_path) }

      context 'with plan limits allowed to create a classroom' do
        before(:all) { classroom.owner.plan.increment!(:allowed_classrooms) }
        it { should redirect_to(classroom_url(
          :subdomain => classroom.owner.created_classrooms.last.slug))
        }
      end
    end
  end

  describe 'GET edit' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:edit) }
    end
  end

  describe 'PUT update' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }
    let(:member) { '' }
    let(:collab) { '' }

    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description,
        :slug => attrs.slug, :header_image => attrs.header_image
      }, :member_email => member, :collaborator_email => collab)
    end

    context 'being logged in as owner' do
      before { classroom.reload }
      it do
        should redirect_to(edit_classroom_url(:subdomain => classroom.slug))
        classroom.title.should eq(attrs.title)
      end

      context 'with a custom slug' do
        before(:all) { attrs.slug = Faker::Lorem.sentence[0..31] }

        it do
          classroom.reload.slug.should eq(attrs.slug.parameterize)
          should redirect_to(edit_classroom_url(:subdomain => classroom.slug))
        end
      end

      context 'with an invalid new header image' do
        before(:all) do
          attrs.header_image = fixture_file_upload('/test.png', 'image/png')
        end

        it do
          classroom.reload.header_image.should be_nil
          should redirect_to(edit_classroom_url(:subdomain => classroom.slug))
        end
      end

      context 'with a valid new header image' do
        before(:all) do
          # Stub original config to fit the fixture width/height
          Courseware.config.should_receive(:header_image_size).and_return(
            { :width => 400, :height => 479 })
          attrs.header_image = fixture_file_upload('/test.png', 'image/png')
        end

        it do
          classroom.reload.header_image.should eq(classroom.images.last.id)
          should redirect_to(edit_classroom_url(:subdomain => classroom.slug))
        end
      end

      context 'adds a new member' do
        let(:member) { Fabricate(:confirmed_user).email }

        it { classroom.members.map(&:email).should include(member) }
      end

      context 'does not add a new collaborator' do
        let(:collab) { Fabricate(:confirmed_user).email }

        it { classroom.collaborators.map(&:email).should_not include(collab) }

        context 'except when limits allow this' do
          before(:all) {classroom.owner.plan.increment!(:allowed_collaborators)}

          it { classroom.collaborators.map(&:email).should include(collab) }
        end
      end
    end
  end

  describe 'POST announce' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:announce, :use_route => :coursewareable,
           :announcement => attrs.description)
    end

    context 'being logged in as owner' do
      it { should redirect_to(dashboard_classroom_path) }
      it { classroom.all_activities.first.key.should eq('announcement.create')}
      it { classroom.all_activities.first.parameters[:content].should(
        eq(attrs.description)) }
    end
  end

end
