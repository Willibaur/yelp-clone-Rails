class Restaurant < ActiveRecord::Base
  belongs_to :user

  has_many :reviews, dependent: :destroy

  validates :name, length: {minimum: 3}, uniqueness: true

  def owned_by?(user)
    user == self.user
  end

  def average_rating
    return 'N/A' if reviews.none?
    reviews.inject(0) {|memo, review| memo + review.rating} / reviews.length 
  end
end
