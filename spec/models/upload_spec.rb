require 'spec_helper'
require "paperclip/matchers"

describe Upload do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should belong_to(:user)}
  it { should belong_to(:classroom)}
  it { should belong_to(:assetable)}

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:classroom) }
  it { should validate_presence_of(:assetable) }
end
