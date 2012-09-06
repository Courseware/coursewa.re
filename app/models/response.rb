class Response < ActiveRecord::Base
  include PublicActivity::Model

  attr_accessible :content

  # Dynamic quiz store
  store :quiz, :accessors => [:answers, :coverage]
  serialize :answers, Hash
  serialize :coverage, Float

  # Relationships
  belongs_to :assignment
  belongs_to :user
  belongs_to :classroom

  has_many :images, :as => :assetable, :class_name => Image
  has_many :uploads, :as => :assetable, :class_name => Image

  # Validations
  validates_presence_of :content

  # Track activities
  tracked :owner => :user, :recipient => :classroom

  # Callbacks
  # Cleanup title and description before saving it
  before_validation do
    self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
  end
end
