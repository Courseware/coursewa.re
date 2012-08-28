# Generic uploaded file, STI from Asset
class Upload < Asset
  # Relationships
  has_attached_file :attachment
end
