require 'spec_helper'

describe 'Lectures' do
  let(:classroom) { Fabricate('coursewareable/classroom') }

  it 'should not show lectures element if no lectures exist and logged in' do
    sign_in_with(classroom.owner.email)
    visit syllabus_url(:subdomain => classroom.slug)
    page.should_not have_css('#lectures-tree')
  end

  it 'should create lecture if logged in' do
    sign_in_with(classroom.owner.email)
    visit new_lecture_url(:subdomain => classroom.slug)

    lecture = Fabricate.build('coursewareable/lecture',
      :classroom => classroom, :user => classroom.owner, :position => rand(10))

    page.fill_in('lecture_title', :with => lecture.title)
    page.fill_in('lecture_requisite', :with => lecture.requisite)
    page.fill_in('lecture_content', :with => lecture.content)
    page.fill_in('lecture_position', :with => lecture.position)
    page.click_on('submit_lecture')

    page.source.should match(lecture.title)
    page.should have_css('#notifications .success')
    page.should have_css('#lecture')
  end

  describe 'when lecture exists' do
    before {
      @lecture = Fabricate('coursewareable/lecture',
        :user => classroom.owner, :classroom => classroom)
    }

    it 'should show lecture if logged in' do
      sign_in_with(classroom.owner.email)
      visit lecture_url(@lecture, :subdomain => classroom.slug)

      page.should have_content(@lecture.title)
      page.source.should match(@lecture.content)
      page.should have_content(@lecture.requisite)
      page.should have_css('#lecture')
    end

    it 'should update lecture if logged in' do
      sign_in_with(classroom.owner.email)
      visit edit_lecture_url(@lecture, :subdomain => classroom.slug)

      lecture = Fabricate.build('coursewareable/lecture', :position => rand(10),
        :classroom => classroom, :user => classroom.owner)

      page.fill_in('lecture_title', :with => lecture.title)
      page.fill_in('lecture_requisite', :with => lecture.requisite)
      page.fill_in('lecture_content', :with => lecture.content)
      page.fill_in('lecture_position', :with => lecture.position)
      page.click_on('submit_lecture')

      page.source.should match(lecture.title)
      page.should have_css('#notifications .success')
    end

    context 'and another lecture exists' do
      before do
        @parent_lecture = Fabricate('coursewareable/lecture',
          :classroom => classroom, :user => classroom.owner)
      end

      it 'should allow setting another lecture as a parent lecture' do
        sign_in_with(classroom.owner.email)
        visit edit_lecture_url(@lecture, :subdomain => classroom.slug)

        @lecture.parent_lecture.should be_nil

        page.select(@parent_lecture.title, :from => 'lecture_parent_lecture_id')
        page.click_on('submit_lecture')

        page.source.should match(@lecture.title)
        page.should have_css('#notifications .success')
        @lecture.reload.parent_lecture.id.should eq(@parent_lecture.id)
      end
    end
  end

end
