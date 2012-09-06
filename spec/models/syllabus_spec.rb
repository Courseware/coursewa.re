require 'spec_helper'

describe Syllabus do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }

  describe 'with all attributes' do
    subject{ Fabricate(:syllabus) }

    its(:activities){ should_not be_empty }

    it 'should generate a new activity' do
      subject.user.activities.collect(&:key).should include('syllabus.create')
      subject.user.activities.collect(&:recipient).should(
        include(subject.classroom)
      )
    end
  end

  describe 'sanitization' do
    it 'should not allow any html' do
      bad_input = '
      <h1>Heading</h1>
      <ol><li>Name</li></ol>
      <em>Content</em>
      http://www.youtube.com/watch?v=VID30ID
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '
      bad_long_input = Faker::HTMLIpsum.body + '
      http://www.youtube.com/watch?v=VID30ID
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      syllabus = Syllabus.create(
        :title => bad_input,
        :content => bad_long_input,
        :intro => bad_input
      )
      syllabus.title.should_not match(/\<\>/)
      syllabus.content.should_not match(/\<(script|iframe)\>/)
      syllabus.intro.should_not match(/\<(script|iframe|ul|li|h1)\>/)
      syllabus.intro.should match(/http:\/\/www.youtube.com\/watch\?v=VID30ID/)
    end
  end

end
