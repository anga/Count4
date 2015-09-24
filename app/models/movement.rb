# Column State:Text
#   The state is a 7x6 array that contains each value of the pieces
#     0: Blank
#     1: Player 1
#     2: Player 2
#
# Column user:Integer
#   Contains the value of the player that does the last movement (1 or 2)
#
# Column last_movement:Integer
#   Contains the number of the column where the user put the piece
class Movement < ActiveRecord::Base

  serialize :state, JSON #, Array

  validates :user, inclusion: [1,2, nil]

  def self.new_game
   Movement.create(state: {
                                  :'0'=> ([0,0,0,0,0,0]),
                                  :'1'=> ([0,0,0,0,0,0]),
                                  :'2'=> ([0,0,0,0,0,0]),
                                  :'3'=> ([0,0,0,0,0,0]),
                                  :'4'=> ([0,0,0,0,0,0]),
                                  :'5'=> ([0,0,0,0,0,0]),
                                  :'6' => ([0,0,0,0,0,0])
                                }, user: nil, last_movement: nil)
  end

  def self.move(params)
    col = params[:col].to_i - 1 # -1 because index based
    user = params[:user].to_i
    color = (user == 1) ? 'blue' : 'red'
    @movement = Movement.last

    # 2 times same user not allowd
    if user == @movement.user
      return false
    end

    # Looks for the upper free column
    row = 0
    new_col = @movement.state[row.to_s][col]
    7.times do |i|
      if new_col == 0
        break
      else

        new_col = @movement.state[i.to_s][col]
        row = i
      end
    end

    st = @movement.state.clone
    st[row.to_s][col] = user

    Movement.create(state: st, user: user)
    MovementFayeController.publish('/movements', {action: 'movement', color: color, col: col + 1, row: 7 - row, user: user})

    # Check if a user wins
    Movement.check_win(st, row, col, user)

    return true
  end

  def self.check_win(state, r,c, v)
    # check to the left
    win = false
    win = (
    state[(r-3).to_s][c] == v and
      state[(r-2).to_s][c] == v and
      state[(r-1).to_s][c] == v and
      state[(r).to_s][c] == v
    ) if r-3 >= 0
    win ||=  (
    state[(r-2).to_s][c] == v and
      state[(r-1).to_s][c] == v and
      state[(r).to_s][c] == v and
      state[(r+1).to_s][c] == v
    ) if r+1 < 7 and r - 2 >= 0
    win ||= (
    state[(r-1).to_s][c] == v and
      state[(r).to_s][c] == v and
      state[(r+1).to_s][c] == v and
      state[(r+2).to_s][c] == v
    ) if r+2 < 7 and r - 1 >= 0
    win ||= (
    state[(r).to_s][c] == v and
      state[(r+1).to_s][c] == v and
      state[(r+2).to_s][c] == v and
      state[(r+3).to_s][c] == v
    ) if r+3 < 7
    #### UP
    win ||= ( #UP
    state[(r).to_s][c-3] == v and
      state[(r).to_s][c-2] == v and
      state[(r).to_s][c-1] == v and
      state[(r).to_s][c] == v
    ) if c-3 >= 0
    win ||= (
    state[(r).to_s][c-2] == v and
      state[(r).to_s][c-1] == v and
      state[(r).to_s][c] == v and
      state[(r).to_s][c+1] == v
    ) if c - 2 >= 0 and c +1 < 6
    win ||= (
    state[(r).to_s][c-1] == v and
      state[(r).to_s][c] == v and
      state[(r).to_s][c+1] == v and
      state[(r).to_s][c+2] == v
    ) if c - 1 >= 0 and c + 2 < 6
    win ||= (
    state[(r).to_s][c] == v and
      state[(r).to_s][c+1] == v and
      state[(r).to_s][c+2] == v and
      state[(r).to_s][c+3] == v
    ) if c + 3 < 6

    # Diagonal
    # TODO
    if win == true
      MovementFayeController.publish('/movements', {action: 'win', message: "Player #{v} won the game!!"})
      Movement.new_game
    end
  end
end
