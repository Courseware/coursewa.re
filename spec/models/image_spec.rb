require 'spec_helper'
require "paperclip/matchers"

describe Image do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should validate_attachment_content_type(:attachment)
              .allowing(Image::ALLOWED_TYPES)
              .rejecting('text/plain')
  }
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:assetable)}
end
