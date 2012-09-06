class Assignment < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model

  attr_accessible :content, :title

  # Dynamic quiz store
  store :quiz, :accessors => [:questions, :answers]
  serialize :questions, Hash
  serialize :answers, Hash

  # Relationships
  belongs_to :lecture
  belongs_to :user
  belongs_to :classroom

  has_many :images, :as => :assetable, :class_name => Image
  has_many :uploads, :as => :assetable, :class_name => Image

  # Validations
  validates_presence_of :title, :slug, :content
  validates_uniqueness_of :title, :scope => :classroom_id

  # Generate title slug
  friendly_id :title, :use => :scoped, :scope => :classroom

  # Track activities
  tracked :owner => :user, :recipient => :classroom

  # Callbacks
  # Cleanup title and description before saving it
  before_validation do
    self.title = Sanitize.clean(self.title)
    self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
  end
end
