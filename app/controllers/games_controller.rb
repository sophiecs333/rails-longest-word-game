require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  # Can the word be built out of the original grid
  def included?(attempt, letters)
    attempt.chars.all? { |letter| attempt.count(letter) <= letters.count(letter) }
  end

  # Is the word an English word?
  def english_word?(attempt)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score
    # calculate something here with words
    @attempt = params[:word].upcase
    @letters = params[:grid]

    # how to display this method in the score view?
    if included?(@attempt, @letters)
      if english_word?(@attempt)
        @result = "Congratulations #{@attempt} is a valid English word!"
      else
        @result = "Sorry but #{@attempt} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry, but #{@attempt} cannot be built out of #{@letters}"
    end
  end
end

    # # Return grand score
    # hash session like in params
    #
    # # first save code of current gam and then add up to grand score
    # # use Session but not sure how
    # def grand_score
    #   ttl_score = 0
    #   current_score = 0
    #   included? ? current_score += @word.length : current_score += current_score
    # end
