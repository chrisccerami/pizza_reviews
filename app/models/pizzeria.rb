class Pizzeria < ActiveRecord::Base
  has_many :reviews,
    dependent: :destroy
  has_many :comments, through: :reviews,
    dependent: :destroy

  validates :name, presence: true
  validates :name, length: { in: 2..100 }
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  validates_uniqueness_of :street, scope: [:name, :city, :state]

  def address
    "#{city}, #{state} #{zip_code}"
  end

  def latest_reviews
    reviews.order(created_at: :desc).limit(3)
  end

  def self.search(query)
    where("plainto_tsquery(?) @@ " +
          "to_tsvector('english', name)",
          query)
  end

  mount_uploader :photo, PizzeriaPhotoUploader
end
