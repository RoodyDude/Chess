#command-line chess 
#use nested array for chess board
#Class gamepiece, sub classes for pieces that can only move in definite ways vs picking a spot in a line
class GamePiece
    
end

class Board
    attr_accessor :board
    def initialize
        @board = create_board()
    end

    def create_board
        x = 0
        y = 0
        z = " "
        board = []
        while y < 8 do
            x = 0
            while x < 8 do
                board.append([x,y,z])
                x += 1
            end
            y += 1
        end
        board
    end
end

