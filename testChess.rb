#command-line chess 
#use nested array for chess board
#Class Gamepiece, sub classes for pieces that can only move in definite ways vs picking a spot in a line
LEFT_EDGES = [0,8,16,24,32,40,48,56]
RIGHT_EDGES = [7,15,23,31,39,47,55,63]

class GamePiece
    attr_accessor :color
    def initialize(color)
        @color = color
    end
end

class Pawn < GamePiece
    attr_accessor :color, :moved
    def initialize(color)
        @color = color
        @moved = false
    end

    def to_s
        if @color == "black"
            return "\u265F"
        else 
            return "\u2659"
        end
    end
end

class Rook < GamePiece
    def to_s
        if @color == "black"
            return "\u265C"
        else
            return "\u2656"
        end
    end
end

class Knight < GamePiece
    def to_s
        if @color == "black"
            return "\u265E"
        else
            return "\u2658"
        end
    end
end

class Bishop < GamePiece
    def to_s
        if @color == "black"
            return "\u265D"
        else
            return "\u2657"
        end
    end
end

class Queen < GamePiece
    def to_s
        if @color == "black"
            return "\u265B"
        else
            return "\u2655"
        end
    end
end

class King < GamePiece
    def to_s
        if @color == "black"
            return "\u265A"
        else
            return "\u2654"
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
        @turn = 1
        self.populate_board
    end

    def make_move
        display_eligible_moves(find_unit(get_input()))
    end

    def get_input
        puts "Choose a unit. Hit enter when done."
        choice = gets.chomp.split('').map(&:to_i).map { |x| x - 1 }
        choice
    end

    def find_unit(choice)
        @game_board.grid.each_with_index do |x, index|
            if x[0] == choice[0] && x[1] == choice[1]
                puts "#{[x,index]}"
                return [x,index]
            end
        end
    end

    def display_eligible_moves(unit)
        case unit[0][2]
        when Pawn
            self.show_pawn_moves(unit)
        when Rook
            self.show_rook_moves(unit)
        when Knight
            self.show_knight_moves(unit)
        when Queen
            self.show_queen_moves(unit)
        when King
            self.show_king_moves(unit)
        else
            puts "No piece found. Pick another."
        end
    end

    def show_pawn_moves(unit)
        #identify possible takeover moves
        self.find_pawn_movement(unit)
        self.find_pawn_takeovers(unit)
    end

    def find_pawn_movement(unit)
        if unit[0][2].color == "white"
            move1 = unit[1] + 8
            move2 = unit[1] + 16
        else
            move1 = unit[1] - 8
            move2 = unit[1] - 16
        end

        if unit[0][2].moved == false
            if is_spot_empty?(move1) && is_spot_empty?(move2)
                @game_board.grid[move1][2] = "0"
                @game_board.grid[move2][2] = "0"
                self.display_board
            elsif is_spot_empty?(move1) && !is_spot_empty?(move2)
                @game_board.grid[move1][2] = "0"
                self.display_board
            else 
                self.display_board
            end
        else
            if is_spot_empty(move1)
                @game_board.grid[move1][2] = "0"
                self.display_board
            else
                self.display_board
            end
        end
    end

    def find_pawn_takeovers(unit)
        if LEFT_EDGES.include?(unit[1])
            if @game_board.grid[unit[1] + 9][2] != " "
                puts "Pawn: Possible takeovers: 1"
            end
        elsif RIGHT_EDGES.include?(unit[1])
            if @game_board.grid[unit[1] + 7][2] != " "
                puts "Pawn: Possible takeovers: 1"
            end
        else
            if @game_board.grid[unit[1] + 7][2] != " " && @game_board.grid[unit[1] + 9][2] != " "
                puts "Pawn: Possible takeovers: 2"
            elsif @game_board.grid[unit[1] + 7][2] != " " || @game_board.grid[unit[1] + 9][2] != " "
                puts "Pawn: Possible takeovers: 1"
            else
                puts "Pawn: Possible takeovers: 0"
            end
        end
    end

    def is_spot_empty?(grid_number)
        begin
            spot = @game_board.grid[grid_number][2]
        rescue
            return false
        end
        if spot == " "
            return true
        else
            return false
        end
    end

    def move_piece(start, finish)
        @game_board.grid[finish][2] = @game_board.grid[start].delete_at(2)
        @game_board.grid[start].push(" ")
    end

    def populate_board
        self.place_white_pieces()
        self.place_black_pieces()
    end

    def place_black_pieces
        x = 48
        while x < 56 do
            @game_board.grid[x][2] = Pawn.new("black")
            x+=1
        end
        @game_board.grid[56][2] = Rook.new("black")
        @game_board.grid[63][2] = Rook.new("black")
        @game_board.grid[57][2] = Knight.new("black")
        @game_board.grid[62][2] = Knight.new("black")
        @game_board.grid[58][2] = Bishop.new("black")
        @game_board.grid[61][2] = Bishop.new("black")
        @game_board.grid[59][2] = Queen.new("black")
        @game_board.grid[60][2] = King.new("black")
    end

    def place_white_pieces
        x = 8
        while x < 16 do
            @game_board.grid[x][2] = Pawn.new("white")
            x+=1
        end
        @game_board.grid[0][2] = Rook.new("white")
        @game_board.grid[7][2] = Rook.new("white")
        @game_board.grid[1][2] = Knight.new("white")
        @game_board.grid[6][2] = Knight.new("white")
        @game_board.grid[2][2] = Bishop.new("white")
        @game_board.grid[5][2] = Bishop.new("white")
        @game_board.grid[3][2] = Queen.new("white")
        @game_board.grid[4][2] = King.new("white")
    end

    def display_board
        puts "  ---------------------------------"
        puts "8 | #{@game_board.grid[56][2]} | #{@game_board.grid[57][2]} | #{@game_board.grid[58][2]} | #{@game_board.grid[59][2]} | #{@game_board.grid[60][2]} | #{@game_board.grid[61][2]} | #{@game_board.grid[62][2]} | #{@game_board.grid[63][2]} |"
        puts "  ---------------------------------"
        puts "7 | #{@game_board.grid[48][2]} | #{@game_board.grid[49][2]} | #{@game_board.grid[50][2]} | #{@game_board.grid[51][2]} | #{@game_board.grid[52][2]} | #{@game_board.grid[53][2]} | #{@game_board.grid[54][2]} | #{@game_board.grid[55][2]} |"
        puts "  ---------------------------------"
        puts "6 | #{@game_board.grid[40][2]} | #{@game_board.grid[41][2]} | #{@game_board.grid[42][2]} | #{@game_board.grid[43][2]} | #{@game_board.grid[44][2]} | #{@game_board.grid[45][2]} | #{@game_board.grid[46][2]} | #{@game_board.grid[47][2]} |"
        puts "  ---------------------------------"
        puts "5 | #{@game_board.grid[32][2]} | #{@game_board.grid[33][2]} | #{@game_board.grid[34][2]} | #{@game_board.grid[35][2]} | #{@game_board.grid[36][2]} | #{@game_board.grid[37][2]} | #{@game_board.grid[38][2]} | #{@game_board.grid[39][2]} |"
        puts "  ---------------------------------"
        puts "4 | #{@game_board.grid[24][2]} | #{@game_board.grid[25][2]} | #{@game_board.grid[26][2]} | #{@game_board.grid[27][2]} | #{@game_board.grid[28][2]} | #{@game_board.grid[29][2]} | #{@game_board.grid[30][2]} | #{@game_board.grid[31][2]} |"
        puts "  ---------------------------------"
        puts "3 | #{@game_board.grid[16][2]} | #{@game_board.grid[17][2]} | #{@game_board.grid[18][2]} | #{@game_board.grid[19][2]} | #{@game_board.grid[20][2]} | #{@game_board.grid[21][2]} | #{@game_board.grid[22][2]} | #{@game_board.grid[23][2]} |"
        puts "  ---------------------------------"
        puts "2 | #{@game_board.grid[8][2]} | #{@game_board.grid[9][2]} | #{@game_board.grid[10][2]} | #{@game_board.grid[11][2]} | #{@game_board.grid[12][2]} | #{@game_board.grid[13][2]} | #{@game_board.grid[14][2]} | #{@game_board.grid[15][2]} |"
        puts "  ---------------------------------"
        puts "1 | #{@game_board.grid[0][2]} | #{@game_board.grid[1][2]} | #{@game_board.grid[2][2]} | #{@game_board.grid[3][2]} | #{@game_board.grid[4][2]} | #{@game_board.grid[5][2]} | #{@game_board.grid[6][2]} | #{@game_board.grid[7][2]} |"
        puts "  ---------------------------------"
        puts "    1   2   3   4   5   6   7   8"
    end
end
game = Game.new
game.display_board
game.move_piece(49,17)
game.display_board
game.display_eligible_moves(game.find_unit(game.get_input))