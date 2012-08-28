# Asset/Upload STI model
class Asset < ActiveRecord::Base
  attr_accessible :attachment_file_name, :attachment_file_size, :description

  # Relationships
  belongs_to :assetable, :polymorphic => true
  delegate :url, :to => :attachment

  # Validations
  validates_attachment_size :attachment, :less_than => Proc.new{
    |img| img.user.plan.left_space
  }

  # Callbacks

  # Increment user used space
  after_create do
    user.plan.increment!(:used_space, attachment_file_size)
  end

  # Decrement freed space
  before_destroy do
    user.plan.decrement!(:used_space, attachment_file_size)
  end
end
