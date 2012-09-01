require 'spec_helper'

describe Course do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:parent_course) }

  describe 'with all attributes' do
    subject{ Fabricate(:course) }

    it { should validate_uniqueness_of(:title).scoped_to(:classroom_id) }
    it { should respond_to(:slug) }

    its(:parent_course){ should be_nil }
    its(:activities){ should_not be_empty }

    it 'should generate a new activity' do
      subject.user.activities.collect(&:key).should include('course.create')
      subject.user.activities.collect(&:recipient).should(
        include(subject.classroom)
      )
    end
  end

  describe 'sanitization' do
    it 'should not allow html' do
      bad_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      course = Course.create(
        :title => bad_input,
        :content => bad_input,
        :requisite => bad_input
      )
      course.title.should_not match(/\<\>/)
      course.content.should_not match(/\<(script|iframe)\>/)
      course.requisite.should_not match(/\<(script|iframe)\>/)
      course.requisite.should_not match(/\<(h1|li|ol)\>/)
    end
  end
end
