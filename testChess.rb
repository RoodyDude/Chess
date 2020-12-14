#command-line chess 
#use nested array for chess board
#Class Gamepiece, sub classes for pieces that can only move in definite ways vs picking a spot in a line
class GamePiece
    attr_accessor :type, :color
    def initialize(type, color)
        @type = type
        @color = color
    end
    
    def to_s
        if @color == "black"
            case @type
            when "pawn"
                return "\u265F"
            when "rook"
                return "\u265C"
            when "knight"
                return "\u265E"
            when "bishop"
                return "\u265D"
            when "queen"
                return "\u265B"
            when "king"
                return "\u265A"
            end
        else
            case @type
            when "pawn"
                return "\u2659"
            when "rook"
                return "\u2656"
            when "knight"
                return "\u2658"
            when "bishop"
                return "\u2657"
            when "queen"
                return "\u2655"
            when "king"
                return "\u2654"
            end
        end
    end
end

class Board
    attr_accessor :grid
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
        @game_board = Board.new
    end

    def populate_board
        self.place_white_pieces()
        self.place_black_pieces()
    end

    def place_black_pieces
        x = 48
        while x < 56 do
            @game_board.grid[x][2] = GamePiece.new("pawn", "black")
            x+=1
        end
        @game_board.grid[56][2] = GamePiece.new("rook", "black")
        @game_board.grid[63][2] = GamePiece.new("rook", "black")
        @game_board.grid[57][2] = GamePiece.new("knight", "black")
        @game_board.grid[62][2] = GamePiece.new("knight", "black")
        @game_board.grid[58][2] = GamePiece.new("bishop", "black")
        @game_board.grid[61][2] = GamePiece.new("bishop", "black")
        @game_board.grid[59][2] = GamePiece.new("queen", "black")
        @game_board.grid[60][2] = GamePiece.new("king", "black")
    end

    def place_white_pieces
        x = 8
        while x < 16 do
            @game_board.grid[x][2] = GamePiece.new("pawn", "white")
            x+=1
        end
        @game_board.grid[0][2] = GamePiece.new("rook", "white")
        @game_board.grid[7][2] = GamePiece.new("rook", "white")
        @game_board.grid[1][2] = GamePiece.new("knight", "white")
        @game_board.grid[6][2] = GamePiece.new("knight", "white")
        @game_board.grid[2][2] = GamePiece.new("bishop", "white")
        @game_board.grid[5][2] = GamePiece.new("bishop", "white")
        @game_board.grid[3][2] = GamePiece.new("queen", "white")
        @game_board.grid[4][2] = GamePiece.new("king", "white")
    end

    def display_board
        puts "---------------------------------"
        puts "| #{@game_board.grid[56][2]} | #{@game_board.grid[57][2]} | #{@game_board.grid[58][2]} | #{@game_board.grid[59][2]} | #{@game_board.grid[60][2]} | #{@game_board.grid[61][2]} | #{@game_board.grid[62][2]} | #{@game_board.grid[63][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[48][2]} | #{@game_board.grid[49][2]} | #{@game_board.grid[50][2]} | #{@game_board.grid[51][2]} | #{@game_board.grid[52][2]} | #{@game_board.grid[53][2]} | #{@game_board.grid[54][2]} | #{@game_board.grid[55][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[40][2]} | #{@game_board.grid[41][2]} | #{@game_board.grid[42][2]} | #{@game_board.grid[43][2]} | #{@game_board.grid[44][2]} | #{@game_board.grid[45][2]} | #{@game_board.grid[46][2]} | #{@game_board.grid[47][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[32][2]} | #{@game_board.grid[33][2]} | #{@game_board.grid[34][2]} | #{@game_board.grid[35][2]} | #{@game_board.grid[36][2]} | #{@game_board.grid[37][2]} | #{@game_board.grid[38][2]} | #{@game_board.grid[39][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[24][2]} | #{@game_board.grid[25][2]} | #{@game_board.grid[26][2]} | #{@game_board.grid[27][2]} | #{@game_board.grid[28][2]} | #{@game_board.grid[29][2]} | #{@game_board.grid[30][2]} | #{@game_board.grid[31][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[16][2]} | #{@game_board.grid[17][2]} | #{@game_board.grid[18][2]} | #{@game_board.grid[19][2]} | #{@game_board.grid[20][2]} | #{@game_board.grid[21][2]} | #{@game_board.grid[22][2]} | #{@game_board.grid[23][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[8][2]} | #{@game_board.grid[9][2]} | #{@game_board.grid[10][2]} | #{@game_board.grid[11][2]} | #{@game_board.grid[12][2]} | #{@game_board.grid[13][2]} | #{@game_board.grid[14][2]} | #{@game_board.grid[15][2]} |"
        puts "---------------------------------"
        puts "| #{@game_board.grid[0][2]} | #{@game_board.grid[1][2]} | #{@game_board.grid[2][2]} | #{@game_board.grid[3][2]} | #{@game_board.grid[4][2]} | #{@game_board.grid[5][2]} | #{@game_board.grid[6][2]} | #{@game_board.grid[7][2]} |"
        puts "---------------------------------"
    end
end
game = Game.new
game.display_board
game.place_black_pieces
game.place_white_pieces
game.display_board
#puts "\u2654"