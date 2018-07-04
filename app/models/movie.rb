class Movie < ApplicationRecord
  belongs_to :description, optional: true
  belongs_to :genre
  has_many :reviews, dependent: :destroy
  has_many :watchlists, dependent: :destroy

  validates :genre_id, :image, :release_date, :synopsis, presence: true
  validates :name, presence: true, uniqueness: true

  scope :top_updated, -> {order(created_at: :desc)}
  scope :top_reviewed, -> {joins(:reviews).merge(Review.order created_at: :desc).uniq}

  scope :top_rated, -> {joins(:reviews).where("reviews.created_at >= ?", 
                        Date.today.beginning_of_week).order("reviews.rating DESC").uniq}
  

  scope :top_by, -> (type) {
    case type
    when "top_updated"
      top_updated
    when "top_reviewed"
      top_reviewed
    when "top_rated"
      top_rated
    end
  }

  scope :load_year, ->{select("release_date").map{ |i| i.release_date.year }.uniq}
  scope :genre, -> (genre_id) {where(genre_id: genre_id).order(created_at: :desc)}
  scope :release_year, -> (year) {(where "YEAR(release_date) = ?", year.to_i)
                          .order(created_at: :desc)}
  scope :user_rating, -> (user_rating) {joins(:reviews).where(reviews: {rating: user_rating})
                          .order(created_at: :desc)}

  def count_reviews
    reviews.count
  end

  def avg_ratings
    reviews.average(:rating).to_f.round Settings.movies.ratings_round
  end
end
