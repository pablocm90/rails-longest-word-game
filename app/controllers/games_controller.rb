require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def game

    # creating grid
    grid = []
    10.times { grid << ("A".."Z").to_a.sample(1)[0] }
    @grid = grid
    @grid_joined = @grid.join("")

    @start_time = Time.now


  end

  def score
    @start_time = Time.new(params[:start_time])
    @end_time = Time.now
    @grid = params[:grid].split("")
    result = {}
    word = params[:attempt].upcase.split("")
    url = "https://wagon-dictionary.herokuapp.com/#{params[:attempt]}"
    word_dicc = open(url).read
    word_dicc_h = JSON.parse(word_dicc)
    result[:time] = @end_time - @start_time
    result[:score] = score_calculator(word, result[:time])
    checking(result, @grid, word_dicc_h, word)
    @result = result

  end


  def checking(hash, grid, word_modified, attempt_modified)
    if !word_modified["found"]
      hash[:score] = 0
      hash[:message] = "I am sorry but your word is not an english word"
    elsif (grid & attempt_modified).sort != attempt_modified.sort
      hash[:score] = 0
      hash[:message] = "It's not in the grid"
    else
      hash[:message] = "Well done!"
    end
  end

  def score_calculator(attempt, time)
    partial_score = attempt.length
    score_modifier = 1.0 / time
    (partial_score - 1) + score_modifier
  end

end


# def generate_grid(grid_size)
#   # TODO: generate random grid of letters
#   grid = []
#   grid_size.times { grid << ("A".."Z").to_a.sample(1)[0] }
#   grid
# end

# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result
#   result = {}
#   word = attempt.upcase.split("")
#   url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
#   word_dicc = open(url).read
#   word_dicc_h = JSON.parse(word_dicc)
#   result[:time] = end_time - start_time
#   result[:score] = score_calculator(word, result[:time])

#   checking(result, grid, word_dicc_h, word)
#   result
# end

# def score_calculator(attempt, time)
#   partial_score = attempt.length
#   score_modifier = 1.0 / time
#   (partial_score - 1) + score_modifier
# end

# def checking(hash, grid, word_modified, attempt_modified)
#   if !word_modified["found"]
#     hash[:score] = 0
#     hash[:message] = "I am sorry but your word is not an english word"
#   elsif (grid & attempt_modified).sort != attempt_modified.sort
#     hash[:score] = 0
#     hash[:message] = "It's not in the grid"
#   else
#     hash[:message] = "Well done!"
#   end
# end
