class GamesController < ApplicationController
  # User 1 board
  # GET /games/1
  def board_1
    @actions
  end

  # User 2 board
  # GET /games/2
  def board_2
  end

  # Every user submmit a movement here
  # POST /games/move
  def movement
    @movement = Movement.last
    if Movement.move(params) == false
      render json: 'Other user'
    end
    render json: 'Ok'
  end

  # Clear the board
  # POST /games/new
  def new_game
    # Create a new game with state cleared
    @movement = Movement.new_game
    respond_to do |format|
      format.json do
        # Publish to faye, then the player 2 can see the new board with websocket
        render json: @movement
      end
    end
  end

end