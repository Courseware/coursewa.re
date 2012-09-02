require 'spec_helper'

describe Plan do
  let(:plan){ Fabricate(:user).plan }

  it { should belong_to(:user) }

  Courseware.config.plans.keys do |plan|
    it { should allow_value(plan).for(:slug) }
  end

  context 'with all attributes' do
    subject{ plan }
    its(:used_space){ should eq(0) }

    context 'when a user uploads a file' do
      it 'should update the used space' do
        img = Fabricate(:image, :user => plan.user)
        img_size = img.attachment_file_size

        plan.reload
        plan.used_space.should eq(img_size)
        plan.left_space.should eq(plan.allowed_space - img_size)
      end
    end

    context 'when a user deletes a file' do
      it 'should update the used space' do
        img = Fabricate(:image, :user => plan.user)
        img_size = img.attachment_file_size
        initial_used_space = plan.reload.used_space

        img.destroy
        plan.reload
        plan.used_space.should eq(initial_used_space - img_size)
      end
    end

    context 'when a user reached plan limits' do
      before{ plan.update_attribute(:allowed_space, 0) }

      it 'should fail uploading new files' do
        plan.reload
        plan.allowed_space.should eq(0)

        initial_used_space = plan.reload.used_space
        expect{
          Fabricate(:image, :user => plan.user)
        }.to raise_error(ActiveRecord::RecordInvalid, /Attachment file size/)

        plan.reload
        plan.used_space.should eq(initial_used_space)
      end
    end

  end

end
