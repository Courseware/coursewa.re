require 'spec_helper'
require "paperclip/matchers"

describe Upload do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should respond_to(:assetable)}
end
