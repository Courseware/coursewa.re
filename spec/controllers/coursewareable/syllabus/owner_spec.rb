require 'spec_helper'

describe Coursewareable::SyllabusesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET show' do
    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:show, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:show) }
    end
  end

  describe 'GET edit' do
    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'logged in as owner' do
      it { should render_template(:edit) }
    end
  end

  describe 'POST create' do
    let(:syllabus) { Fabricate.build('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :syllabus => {
        :title => syllabus.title, :content => syllabus.content,
        :intro => syllabus.intro
      })
    end

    context 'being logged in as owner' do
      it { should render_template(:show) }

      context 'when syllabus exists' do
        before(:all) do
          @syl = Fabricate('coursewareable/syllabus', :classroom => classroom)
          @syl_count = Coursewareable::Syllabus.count
        end

        it do
          should render_template(:show)
          @syl_count.should eq(Coursewareable::Syllabus.count)
          @syl.title.should eq(classroom.syllabus.title)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:syllabus) { Fabricate.build('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :syllabus => {
        :title => syllabus.title, :content => syllabus.content
      })
    end

    context 'being logged in as owner' do
      it 'wont update syllabus if it was not created first' do
        should redirect_to(edit_syllabus_path)
        classroom.syllabus.should be_nil
      end

      context 'and syllabus exist' do
        before(:all) do
          Fabricate('coursewareable/syllabus', :classroom => classroom,
                    :user => classroom.owner)
        end

        it 'updates the syllabus' do
          should render_template(:show)
          classroom.syllabus.title.should eq(syllabus.title)
        end
      end
    end
  end

end
