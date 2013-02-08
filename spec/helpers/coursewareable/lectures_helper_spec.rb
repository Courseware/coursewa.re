# encoding: utf-8
require 'spec_helper'

describe Coursewareable::LecturesHelper do
  describe '#list_lecture_options' do
    let(:parent_lecture) { Fabricate('coursewareable/lecture') }
    let(:lecture) do
      Fabricate('coursewareable/lecture',
                :parent_lecture_id => parent_lecture.id)
    end
    let(:lectures) { [parent_lecture, lecture] }
    let(:selected) { nil }

    subject { helper.list_lecture_options(lectures, selected) }

    it { should match('– ' + lecture.title) }
    it { should match(parent_lecture.title) }

    context 'with selected value' do
      let(:selected) { parent_lecture.id }

      it { should match("selected value='#{selected}'") }
    end

    context 'with a nil argument' do
      let(:lectures) { nil }

      it { should eq(nil) }
    end
  end
end
