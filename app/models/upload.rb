# Generic uploaded file, STI from Asset
class Upload < Asset
  # Relationships
  belongs_to :user
  belongs_to :classroom
  has_attached_file :attachment
end
