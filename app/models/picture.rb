class Picture < ActiveRecord::Base
  belongs_to :user

  mount_uploader :file, PictureUploader
end
