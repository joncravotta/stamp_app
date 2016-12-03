class Slice < ActiveRecord::Base
  mount_uploader :slices, SlicerUploader
  mount_uploader :image, SliceUploader
end
