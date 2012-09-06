require 'spec_helper'

describe Response do
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:assignment) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }

  describe 'with all attributes' do
    subject{ Fabricate(:response) }

    it { should respond_to(:answers) }
    it { should respond_to(:coverage) }

    its(:activities){ should_not be_empty }

    it 'should generate a new activity' do
      subject.user.activities.collect(&:key).should(
        include('response.create'))
      subject.user.activities.collect(&:recipient).should(
        include(subject.classroom)
      )
    end
  end

  describe 'sanitization' do
    it 'should not allow html' do
      bad_long_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      response = Response.create(
        :content => bad_long_input
      )
      response.content.should_not match(/\<(script|iframe)\>/)
    end
  end

  describe 'answers/coverage' do
    it 'should properly serialize attributes' do
      response = Response.create(
        :content => Faker::HTMLIpsum.body
      )

      response.answers = { :first => [Faker::Lorem.word, Faker::Lorem.word] }
      response.coverage = 91.6

      response.save
      response.reload

      response.answers.keys.should include(:first)
      response.answers[:first].should_not be_empty

      response.coverage.should eq(91.6)
    end
  end
end
