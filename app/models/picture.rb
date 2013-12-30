class Picture < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  mount_uploader :file, PictureUploader
end
