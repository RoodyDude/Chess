#command-line chess 
#use nested array for chess board
#Class Gamepiece, sub classes for pieces that can only move in definite ways vs picking a spot in a line
class GamePiece
    attr_accessor :type, :color
    def initialize(type, color)
        @type = type
        @color = color
    end
end

class Board
    attr_accessor :board
    def initialize
        @grid = create_board()
    end

    def create_board
        x = 0
        y = 0
        z = " "
        grid = []
        while y < 8 do
            x = 0
            while x < 8 do
                grid.append([x,y,z])
                x += 1
            end
            y += 1
        end
        grid
    end
end

class Game
    def initialize
        @board = Board.new
    end

    def populate_board
        self.place_white_pieces()
        self.place_black_pieces()
    end

    def place_black_pieces
        
    end

    def place_white_pieces

    end
end
