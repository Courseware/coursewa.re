require 'spec_helper'

describe Coursewareable::SyllabusesHelper do
  describe '#list_lecture_options' do
    let(:parent_lecture) { Fabricate('coursewareable/lecture') }
    let(:lecture) do
      Fabricate('coursewareable/lecture',
                :parent_lecture_id => parent_lecture.id)
    end
    let(:lectures) { [parent_lecture, lecture] }

    before do
      # Mock view to avoid hitting the controller/routes
      view.should_receive(:lecture_path).twice.and_return(root_path)
    end

    subject { helper.list_lectures_tree(lectures) }

    it { should match(lecture.title) }
    it { should match(parent_lecture.title) }
  end
end

