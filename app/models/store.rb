class Store < ApplicationRecord
  has_many :users
  has_many :staffs
  # CarrierWave 画像をURL経由で表示させる Store.image.url で表示可能
  mount_uploader :image, ImageUploader
  validates :name, presence: true, length: { maximum: 50 }
  validates :phone, length: { maximum: 15 }
  validates :email, length: { maximum: 50 }
  validates :line_id, length: { maximum: 50 }
  validates :address, length: { maximum: 100 }
end
