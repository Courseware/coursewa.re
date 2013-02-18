require 'spec_helper'

describe Coursewareable::ApplicationHelper do
  describe '#title' do
    let(:title_text) { Faker::Lorem.sentence }
    before(:each) { @view_flow = ActionView::OutputFlow.new }

    subject { helper.content_for(:title) }

    context 'when no title was set' do
      it { should be_empty }
    end

    context 'when title was set' do
      before { title(title_text) }

      it { should match(title_text) }
    end
  end

  describe '#head_embed' do
    let(:content_text) { Faker::Lorem.sentence }

    before(:each) { @view_flow = ActionView::OutputFlow.new }

    subject { helper.content_for(:head_embed) }

    context 'when no head_embed was set' do
      it { should be_empty }
    end

    context 'when head_embed was set' do
      before { head_embed(content_text) }

      it { should match(content_text) }
    end
  end

  describe '#breadcrumbs' do
    let(:content_text) { Faker::Lorem.sentence }

    before(:each) { @view_flow = ActionView::OutputFlow.new }

    subject { helper.content_for(:breadcrumbs) }

    context 'when no breadcrumbs was set' do
      it { should be_empty }
    end

    context 'when breadcrumbs was set' do
      before { breadcrumbs(content_text) }

      it { should match(content_text) }
    end
  end

  describe '#header_image' do
    let(:image) { Fabricate('coursewareable/image') }
    let(:classroom) { image.classroom }

    subject { helper.header_image }

    context 'missing @classroom object' do
      it { should be_nil }
    end

    context 'with a valid @classroom object' do
      before do
        classroom.header_image = image.id
        assign(:classroom, classroom)
      end

      it { should match(image.attachment_file_name) }
    end
  end

  describe '#default_header_image' do
    let(:classroom) { Fabricate('coursewareable/classroom') }

    subject { helper.default_header_image }

    context 'missing @classroom object' do
      it { should be_nil }
    end

    context 'with a valid @classroom object' do
      before do
        classroom.id = 3
        assign(:classroom, classroom)
      end

      it { should match('assets/headers/3.jpg') }
    end
  end

  describe '#auto_oembed' do
    let(:youtube_link) { 'https://www.youtube.com/watch?v=XxGr6Wnkp64' }
    let(:flikr_link) { 'http://www.flickr.com/photos/brumlive/4414821637' }
    let(:dummy_link) { 'http://this.is.not.an.oembed.link.com' }

    let(:link) { '' }
    let(:text) do
      %Q(Here take a look at this media #{link}. It should look nice.)
    end

    subject { helper.auto_oembed(text) }

    context 'for content with no links' do
      let(:text) { '' }

      it { should eq('') }
    end

    context 'for content with no links' do
      before { OEmbed::Providers.should_not_receive(:get) }

      it { should eq(text) }
    end

    context 'for content with no oembed links' do
      let(:link) { dummy_link }

      it { should eq(text) }
    end

    context 'for content with oembed links' do
      let(:link) { youtube_link + ' ' + flikr_link }

      it do
        should match(/\<iframe/)
        should match(/\<img/)
      end
    end

  end
end
