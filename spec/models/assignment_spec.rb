require 'spec_helper'

describe Assignment do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:lecture) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_many(:responses).dependent(:destroy) }
  it { should have_many(:grades).dependent(:destroy) }

  describe 'with all attributes' do
    subject{ Fabricate(:assignment) }

    it { should validate_uniqueness_of(:title).scoped_to(:classroom_id) }
    it { should respond_to(:slug) }
    it { should respond_to(:questions) }
    it { should respond_to(:answers) }

    its(:activities){ should_not be_empty }

    it 'should generate a new activity' do
      subject.user.activities.collect(&:key).should(
        include('assignment.create'))
      subject.user.activities.collect(&:recipient).should(
        include(subject.classroom)
      )
    end
  end

  describe 'sanitization' do
    it 'should not allow html' do
      bad_input = '
      <h1>Heading</h1>
      <ol><li>Name</li></ol>
      <em>Content</em>
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '
      bad_long_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      assignment = Assignment.create(
        :title => bad_input,
        :content => bad_long_input
      )
      assignment.title.should_not match(/\<\>/)
      assignment.content.should_not match(/\<(script|iframe)\>/)
    end
  end

  describe 'questions/answers' do
    it 'should properly serialize attributes' do
      assignment = Assignment.create(
        :title => Faker::Lorem.sentence,
        :content => Faker::HTMLIpsum.body
      )

      assignment.questions = { :first => Faker::Lorem.sentence }
      assignment.answers = { :first => [Faker::Lorem.word, Faker::Lorem.word] }

      assignment.save
      assignment.reload

      assignment.questions.keys.should include(:first)
      assignment.questions[:first].should_not be_empty
      assignment.answers.keys.should include(:first)
      assignment.answers[:first].should_not be_empty
    end
  end
end
