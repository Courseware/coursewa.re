# Asset/Upload STI model
class Asset < ActiveRecord::Base
  attr_accessible :attachment_file_name, :attachment_file_size, :description

  # Relationships
  belongs_to :assetable, :polymorphic => true
  delegate :url, :to => :attachment
end
