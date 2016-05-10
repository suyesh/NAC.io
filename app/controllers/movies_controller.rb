

class MoviesController < ApplicationController
    def index
        @movies = Movie.all
    end

    def new
        @movie = Movie.new
    end

    def create
        require 'rest_client'
        require 'json'
        imdb_url = 'http://www.imdb.com/title/'
        movie_title = movie_params['title'].delete(' ')
        response = RestClient.get "http://api-public.guidebox.com/v1.43/US/rK841eDHiiigCOmzLaHpFerPsWOiKird/search/movie/title/#{movie_title}"
        data = JSON.load response
        @movie = Movie.new
        if data['results'].empty?
            flash[:alert] = "Did you spell the Title correctly? Or Maybe we could not find the movie you are looking for."
            render 'new'
        else
            @movie = Movie.new(gb_id: data['results'][0]['id'],
                               title: data['results'][0]['title'],
                               release_year: data['results'][0]['release_year'],
                               imdb_link: (imdb_url + data['results'][0]['imdb']).to_s,
                               rating: data['results'][0]['rating'],
                               small_img: data['results'][0]['poster_120x171'],
                               med_img: data['results'][0]['poster_240x342'],
                               large_img: data['results'][0]['poster_400x570'])
            if @movie.save
                flash[:notice] = 'Movie has been successfully Added.'
                redirect_to @movie
            else
                flash[:alert] = "Something went wrong. Please try again."
                render 'new'
            end
      end
    end

    def show
        @movie = Movie.find(params[:id])
    end

    private

    def movie_params
        params.require(:movie).permit(:title)
    end

    def set_movie
    end
end
