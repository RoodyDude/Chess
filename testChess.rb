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
                piece = [x[2],index]
                return piece
            end
        end
    end

    def display_eligible_moves(piece)
        case piece[0]
        when Pawn
            self.show_pawn_moves(piece)
        when Rook
            self.show_rook_moves(piece)
        when Knight
            self.show_knight_moves(piece)
        when Bishop
            self.show_bishop_moves(piece)
        when Queen
            self.show_queen_moves(piece)
        when King
            self.show_king_moves(piece)
        else
            puts "No piece found. Pick another."
        end
    end

    def show_pawn_moves(piece)
        self.find_pawn_movement(piece)
        self.find_pawn_takeovers(piece)
    end

    def show_rook_moves(piece)
        self.find_rook_movement(piece)
        self.find_rook_takeovers(piece)
    end

    def show_knight_moves(piece)
        self.find_knight_movement(piece)
        self.find_knight_takeovers(piece)
    end

    def show_bishop_moves(piece)
        self.find_bishop_movement(piece)
        self.find_bishop_takeovers(piece)
    end

    def show_queen_moves(piece)
        self.find_queen_movement(piece)
        self.find_queen_takeovers(piece)
    end

    def show_king_moves(piece)
        self.find_king_movement(piece)
        self.find_king_takeovers(piece)
    end

    def find_rook_movement(piece)
        up_marker = piece[1] + 8
        down_marker = piece[1] - 8
        self.find_vertical_options(up_marker, down_marker)
        self.find_horizontal_options(piece[1])
        self.display_board
    end

    def find_rook_takeovers(piece)

    end

    def find_knight_movement(piece)

    end

    def find_knight_takeovers(piece)

    end

    def find_bishop_movement(piece)

    end

    def find_bishop_takeovers(piece)

    end

    def find_queen_movement(piece)

    end
    
    def find_queen_takeovers(piece)

    end

    def find_king_movement(piece)

    end

    def find_king_takeovers(piece)

    end

    def find_pawn_movement(piece)
        if piece[0].color == "white"
            move1 = piece[1] + 8
            move2 = piece[1] + 16
        else
            move1 = piece[1] - 8
            move2 = piece[1] - 16
        end

        if piece[0].moved == false
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

    def find_pawn_takeovers(piece)
        if piece[1] < 8 || piece[1] > 55
            puts "No possible takeovers"
            return
        end
        if piece[0].color == "white"
            right_target = @game_board.grid[piece[1] + 9]
            left_target = @game_board.grid[piece[1] + 7]
            self.show_pawn_takeover_hint(left_target, right_target, piece)
        else
            right_target = @game_board.grid[piece[1] - 7]
            left_target = @game_board.grid[piece[1] - 9]
            self.show_pawn_takeover_hint(left_target, right_target, piece)
        end
    end

    def show_pawn_takeover_hint(left_target, right_target, piece)
        begin
            color1 = right_target[2].color
        rescue
            color1 = piece[0].color
        end

        begin
            color2 = left_target[2].color
        rescue
            color2 = piece[0].color
        end

        if LEFT_EDGES.include?(piece[1]) && color1 != piece[0].color
            puts "Pawn: Possible takeovers: 1"
        elsif RIGHT_EDGES.include?(piece[1]) && color2 != piece[0].color
            puts "Pawn: Possible takeovers: 1"
        elsif color1 != piece[0].color && color2 != piece[0].color
            puts "Pawn: Possible takeovers: 2"
        elsif color1!= piece[0].color || color2 != piece[0].color
            puts "Pawn: Possible takeovers: 1"
        else
            puts "No possible takeovers."
        end
    end

    def find_vertical_options(up_marker, down_marker)
        while up_marker <= 63
            if @game_board.grid[up_marker][2] == " "
                @game_board.grid[up_marker][2] = "0"
                up_marker += 8
            else
                break
            end
        end

        while down_marker >= 0
            if @game_board.grid[down_marker][2] == " "
                @game_board.grid[down_marker][2] = "0"
                down_marker -= 8
            else
                break
            end
        end
    end

    def find_horizontal_options(index)
        if LEFT_EDGES.include?(index)
            self.show_right_options(index+1)
        elsif RIGHT_EDGES.include?(index)
            self.show_left_options(index-1)
        else
            self.show_right_options(index+1)
            self.show_left_options(index-1)
        end        
    end

    def show_right_options(right_marker)
        end_of_line = false
        until end_of_line == true do
            if LEFT_EDGES.include?(right_marker)
                end_of_line = true
            elsif is_spot_empty?(right_marker)
                @game_board.grid[right_marker][2] = "0"
                right_marker += 1
                next
            else
                break
            end
        end
    end

    def show_left_options(left_marker)
        end_of_line = false
        until end_of_line == true do
            if RIGHT_EDGES.include?(left_marker)
                end_of_line = true
            elsif is_spot_empty?(left_marker)
                @game_board.grid[left_marker][2] = "0"
                left_marker -= 1
                next
            else
                break
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
game.move_piece(8,24)
game.move_piece(9,39)
game.move_piece(0,30)
game.display_board
game.display_eligible_moves(game.find_unit(game.get_input))
game.display_board