class StaticPageController < ApplicationController
  def home
    @newest = Movie.top_updated.first Settings.movies.limit
    @new_reviewes = Movie.top_reviewed.first Settings.movies.limit
    @top_rated = Movie.top_rated.first Settings.movies.limit
  end

  def search
    movie_search = @search.result
    @movies = movie_search.paginate page: params[:page], per_page: Settings.movies.page
  end
end
