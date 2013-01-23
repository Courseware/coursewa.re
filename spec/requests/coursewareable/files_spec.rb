require 'spec_helper'

describe 'Files' do
  let(:classroom) { Fabricate('coursewareable/classroom') }

  context 'when there are no files' do
    it 'shows no link in the menu and a clean page' do
      sign_in_with(classroom.owner.email)
      visit dashboard_classroom_url(:subdomain => classroom.slug)

      page.source.should_not match(files_path)

      visit files_url(:subdomain => classroom.slug)
      page.should_not have_css('#files .columns h6')
      page.should_not have_css('#files .columns .icon-background')
    end
  end

  context 'when there are files' do
    include ActionView::Helpers::NumberHelper

    let!(:upload) do
      Fabricate('coursewareable/upload', :classroom => classroom,
               :user => classroom.owner)
    end

    it 'shows the file details and current usage in the sidebar' do
      sign_in_with(classroom.owner.email)
      visit dashboard_classroom_url(:subdomain => classroom.slug)

      page.source.should match(files_path)

      visit files_url(:subdomain => classroom.slug)
      page.should have_content(upload.description)


      page.source.should match(upload.attachment_file_name)
      page.source.should match(polymorphic_url(upload.assetable))

      page.should have_content(
        number_to_human_size(classroom.owner.plan.used_space))
      page.should have_content(
        number_to_human_size(classroom.owner.plan.allowed_space))
    end

    it 'allows to remove a file' do
      sign_in_with(classroom.owner.email)
      visit files_url(:subdomain => classroom.slug)

      click_on("remove-file-#{upload.id}")

      page.should_not have_content(upload.description)
      page.should_not have_css("#remove-file-#{upload.id}")
    end
  end

end

