#command-line chess 
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
        @check = false
        self.populate_board
    end

    def start_game
        game_over = false
        puts "Welcome to Chess."
        puts "Game starting in a moment. You can select a spot on the board by typing the X and Y components like this: \"11\""
        puts "Starting game! White goes first."
        self.display_board
        until game_over do
            self.get_user_input
            self.clear_hints
            self.display_board
            @turn += 1
            game_over = self.check_or_check_mate?
        end
    end

    def check_or_check_mate?
        kings_index = self.find_kings
        target_index = self.scan_for_targets
        for king in kings_index do
            if target_index.include?(king)
                @check = true
            else
                @check = false
            end
        end
        return false
    end

    def scan_for_targets
        piece_indexes = self.find_all_piece_indexes
        targets = []
        piece_indexes.each { |piece|
            temp_targets = self.display_eligible_moves([@game_board.grid[piece][2],piece])
            targets += temp_targets[0]
            self.clear_hints
        }
        return targets
    end

    def find_all_piece_indexes
        pieces_index = []
        @game_board.grid.each_with_index { |item, index|
            if !is_spot_empty?(index)
                pieces_index.push(index)
            end
        }
        return pieces_index
    end

    def find_kings
        kings_index = []
        @game_board.grid.each_with_index { |item, index|
            if item[2].instance_of? King
                kings_index.push(index)
            end
        }
        return kings_index
    end

    def get_user_input
        choice_made = false
        if @turn.odd?
            @check ? (puts "White: choose a piece. Check is on the board.") : (puts "White: choose a piece.")
            @turn_order = "white"
        else
            @check ? (puts "Black: choose a piece. Check is on the board.") : (puts "Black: choose a piece.")
            @turn_order = "black"
        end

        until choice_made == true do
            choice = self.get_targets_and_index()
            targets = choice[0]
            index = choice[1]
            self.display_board
            if check_for_movement_options() == false && (targets.nil? || targets.empty?)
                puts "No valid movement options. Pick another piece."
                next
            end
            
            puts "Choose a spot to move."
            choice_made = self.get_movement_input(targets, index, find_unit(get_input()))
        end
    end

    def get_targets_and_index
        choice = find_unit(get_input())
        if choice[0] == " " || choice[0].color != @turn_order
            return []
        else
            potential_targets_with_index = self.display_eligible_moves(choice)
            targets = potential_targets_with_index[0]
            index = potential_targets_with_index[1]
            return [targets, index]
        end
    end

    def get_movement_input(targets, index, choice)
        if targets.include?(choice[1]) || @game_board.grid[choice[1]][2] == "0"
            self.move_piece(index, choice[1])
            return true
        else
            self.clear_hints
            self.display_board
            puts "Invalid choice. Select another piece"
            return false
        end
    end

    def check_for_movement_options
        for item in @game_board.grid do
            if item[2] == "0"
                return true
            end
        end
        return false
    end

    def clear_hints
        for item in @game_board.grid do
            if item[2] == "0"
                item[2] = " "
            end
        end
    end

    def get_input
        choice = gets.chomp.split('').map(&:to_i).map { |x| x - 1 }
        choice
    end

    def find_unit(choice)
        @game_board.grid.each_with_index do |x, index|
            if x[0] == choice[0] && x[1] == choice[1]
                piece = [x[2],index]
                return piece
            end
        end
    end

    def display_eligible_moves(piece)
        case piece[0]
        when Pawn
            sum_and_targets = self.show_pawn_moves(piece)
        when Rook
            sum_and_targets = self.show_rook_moves(piece)
        when Knight
            sum_and_targets = self.show_knight_moves(piece)
        when Bishop
            sum_and_targets = self.show_bishop_moves(piece)
        when Queen
            sum_and_targets = self.show_queen_moves(piece)
        when King
            sum_and_targets = self.show_king_moves(piece)
        else
            puts "No piece found. Pick another."
        end
        return [sum_and_targets[1], piece[1], sum_and_targets[0]]
    end

    def show_pawn_moves(piece)
        self.find_pawn_movement(piece)
        sum_and_targets = self.find_pawn_takeovers(piece)
        return sum_and_targets
    end

    def show_rook_moves(piece)
        sum_and_targets = self.find_rook_movement_and_takeovers(piece)
        return sum_and_targets
    end
    
    def show_knight_moves(piece)
        sum_and_targets = self.find_knight_movement_and_takeovers(piece)
        return sum_and_targets
    end

    def show_bishop_moves(piece)
        sum_and_targets = self.find_bishop_movement_and_takeovers(piece)
        return sum_and_targets
    end

    def show_queen_moves(piece)
        sum_and_targets = self.find_queen_movement_and_takeovers(piece)
        return sum_and_targets
    end

    def show_king_moves(piece)
        sum_and_targets = self.find_king_movement_and_takeovers(piece)
        return sum_and_targets
    end

    def find_rook_movement_and_takeovers(piece)
        targets = []
        vert_response = self.find_vertical_options(piece[0], piece[1])
        hori_response = self.find_horizontal_options(piece[0], piece[1])
        sum = 0
        sum += vert_response[0]
        sum += hori_response[0]
        targets += vert_response[1]
        targets += hori_response[1]
        return [sum,targets]
    end

    def find_knight_movement_and_takeovers(piece)
        index = piece[1]
        targets = []
        move1 = find_move1(index, piece[0])
        move2 = find_move2(index, piece[0])
        move3 = find_move3(index, piece[0])
        move4 = find_move4(index, piece[0])
        move5 = find_move5(index, piece[0])
        move6 = find_move6(index, piece[0])
        move7 = find_move7(index, piece[0])
        move8 = find_move8(index, piece[0])
        sum = move1[0] + move2[0] + move3[0] + move4[0] + move5[0] + move6[0] + move7[0] + move8[0]
        targets.push(move1[1], move2[1], move3[1], move4[1], move5[1], move6[1], move7[1], move8[1]).compact!
        return [sum,targets]
    end

    def find_move1(index, piece)
        if index > 47 || RIGHT_EDGES.include?(index)
            return [0]
        else
            spot = index + 17
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move2(index,piece)
        if index > 55 || RIGHT_EDGES.include?(index) || RIGHT_EDGES.include?(index + 1)
            return [0]
        else
            spot = index + 10
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move3(index,piece)
        if index < 8 || RIGHT_EDGES.include?(index) || RIGHT_EDGES.include?(index + 1)
            return [0]
        else
            spot = index - 6
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move4(index,piece)
        if index < 16 || RIGHT_EDGES.include?(index)
            return [0]
        else
            spot = index - 15
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move5(index,piece)
        if index < 16 || LEFT_EDGES.include?(index)
            return [0]
        else
            spot = index - 17
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move6(index,piece)
        if index < 8 || LEFT_EDGES.include?(index) || LEFT_EDGES.include?(index - 1)
            return [0]
        else
            spot = index - 10
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move7(index,piece)
        if index > 55 || LEFT_EDGES.include?(index) || LEFT_EDGES.include?(index - 1)
            return [0]
        else
            spot = index + 6
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_move8(index,piece)
        if index > 47 || LEFT_EDGES.include?(index)
            return [0]
        else
            spot = index + 15
            if is_spot_empty?(spot)
                @game_board.grid[spot][2] = "0"
            else
                if piece.color != @game_board.grid[spot][2].color
                    return [1, spot]
                end
            end
        end
        return [0]
    end

    def find_bishop_movement_and_takeovers(piece)
        targets = []
        response = find_diagonal_options(piece[0], piece[1])
        targets += response[1]
        return [response[0], targets]
    end

    def find_diagonal_options(piece, index)
        targets = []
        up_right_diag = find_first_diag(piece, index)
        down_right_diag = find_second_diag(piece, index)
        up_left_diag = find_third_diag(piece, index)
        down_left_diag = find_fourth_diag(piece, index)
        sum = up_right_diag[0] + down_right_diag[0] + up_left_diag[0] + down_left_diag[0]
        targets.push(up_right_diag[1], down_right_diag[1], up_left_diag[1], down_left_diag[1]).compact!
        return [sum, targets]
    end

    def find_first_diag(piece, index)
        diag_marker = index + 9
        end_of_line = false
        until end_of_line == true do
            if LEFT_EDGES.include?(diag_marker) || index > 55 || diag_marker > 63
                return [0]
            elsif is_spot_empty?(diag_marker)
                @game_board.grid[diag_marker][2] = "0"
                diag_marker += 9
                next
            else
                if @game_board.grid[diag_marker][2].color != piece.color
                    return [1, diag_marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_second_diag(piece, index)
        diag_marker = index - 7
        end_of_line = false
        until end_of_line == true do
            if LEFT_EDGES.include?(diag_marker) || index < 8 || diag_marker < 0
                return [0]
            elsif is_spot_empty?(diag_marker)
                @game_board.grid[diag_marker][2] = "0"
                diag_marker -= 7
                next
            else
                if @game_board.grid[diag_marker][2].color != piece.color
                    return [1, diag_marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_third_diag(piece, index)
        diag_marker = index - 9
        end_of_line = false
        until end_of_line == true do
            if RIGHT_EDGES.include?(diag_marker) || index < 8 || diag_marker < 0
                return [0]
            elsif is_spot_empty?(diag_marker)
                @game_board.grid[diag_marker][2] = "0"
                diag_marker -= 9
                next
            else
                if @game_board.grid[diag_marker][2].color != piece.color
                    return [1, diag_marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_fourth_diag(piece, index)
        diag_marker = index + 7
        end_of_line = false
        until end_of_line == true do
            if RIGHT_EDGES.include?(diag_marker) || index > 55 || diag_marker > 63
                return [0]
            elsif is_spot_empty?(diag_marker)
                @game_board.grid[diag_marker][2] = "0"
                diag_marker += 7
                next
            else
                if @game_board.grid[diag_marker][2].color != piece.color
                    return [1, diag_marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_queen_movement_and_takeovers(piece)
        targets = []
        new_targets = []
        index = piece[1]
        move1 = find_vertical_options(piece[0], index)
        move2 = find_horizontal_options(piece[0],index)
        move3 = find_diagonal_options(piece[0], index)
        sum = move1[0] + move2[0] + move3[0]
        target1 = move1[1].flatten
        target2 = move2[1].flatten
        target3 = move3[1].flatten
        new_targets = target1 + target2 + target3
        return [sum, new_targets]
    end
    
    def find_king_movement_and_takeovers(piece)
        targets = []
        index = piece[1]
        move1 = find_king_move_1(piece[0], index)
        move2 = find_king_move_2(piece[0], index)
        move3 = find_king_move_3(piece[0], index)
        move4 = find_king_move_4(piece[0], index)
        move5 = find_king_move_5(piece[0], index)
        move6 = find_king_move_6(piece[0], index)
        move7 = find_king_move_7(piece[0], index)
        move8 = find_king_move_8(piece[0], index)
        sum = move1[0] + move2[0] + move3[0] + move4[0] + move5[0] + move6[0] + move7[0] + move8[0]
        targets.push(move1[1],move2[1],move3[1],move4[1],move5[1],move6[1],move7[1],move8[1]).compact!
        return [sum, targets]
    end

    def find_king_move_1(piece, index)
        marker = index + 8
        if index > 55
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1, marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_king_move_2(piece, index)
        marker = index + 9
        if index > 55 || RIGHT_EDGES.include?(index)
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
    end
    def find_king_move_3(piece, index)
        marker = index + 1
        if RIGHT_EDGES.include?(index)
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_king_move_4(piece, index)
        marker = index - 7
        if index < 8 || RIGHT_EDGES.include?(index)
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_king_move_5(piece, index)
        marker = index - 8
        if index < 8
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_king_move_6(piece, index)
        marker = index - 9
        if index < 8 || LEFT_EDGES.include?(index)
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_king_move_7(piece, index)
        marker = index - 1
        if LEFT_EDGES.include?(index)
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_king_move_8(piece, index)
        marker = index + 7
        if index > 55 || LEFT_EDGES.include?(index)
            return [0]
        else
            if is_spot_empty?(marker)
                @game_board.grid[marker][2] = "0"
                return [0]
            else
                if @game_board.grid[marker][2].color != piece.color
                    return [1,marker]
                else
                    return [0]
                end
            end
        end
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
            elsif is_spot_empty?(move1) && !is_spot_empty?(move2)
                @game_board.grid[move1][2] = "0"
            end
        else
            if is_spot_empty?(move1)
                @game_board.grid[move1][2] = "0"
            end
        end
    end

    def find_pawn_takeovers(piece)
        if piece[1] < 8 || piece[1] > 55
            return
        end
        if piece[0].color == "white"
            right_target = piece[1] + 9
            left_target = piece[1] + 7
            sum_and_targets = self.show_pawn_takeover_hint(left_target, right_target, piece)
        else
            right_target = piece[1] - 7
            left_target = piece[1] - 9
            sum_and_targets = self.show_pawn_takeover_hint(left_target, right_target, piece)
        end
        return sum_and_targets
    end

    def show_pawn_takeover_hint(left_target, right_target, piece)
        targets = []
        sum = 0
        begin
            color1 = @game_board.grid[right_target][2].color
        rescue
            color1 = piece[0].color
        end

        begin
            color2 = @game_board.grid[left_target][2].color
        rescue
            color2 = piece[0].color
        end

        if LEFT_EDGES.include?(piece[1]) && color1 != piece[0].color
            sum += 1
            targets.append(right_target)
        elsif RIGHT_EDGES.include?(piece[1]) && color2 != piece[0].color
            sum += 1
            targets.append(left_target)
        elsif color1 != piece[0].color && color2 != piece[0].color
            sum += 2
            targets.append(left_target, right_target)
        elsif color1 != piece[0].color
            sum += 1
            targets.append(right_target)
        elsif color2 != piece[0].color
            sum += 1
            targets.append(left_target)
        end
        return [sum, targets]
    end

    def find_vertical_options(piece, index)
        targets = []
        sum = 0
        up_marker = index + 8
        down_marker = index - 8
        while up_marker <= 63
            if is_spot_empty?(up_marker)
                @game_board.grid[up_marker][2] = "0"
                up_marker += 8
            else
                if @game_board.grid[up_marker][2].color != piece.color
                    targets.append(up_marker)
                    sum += 1
                    break
                else
                    break
                end
            end
        end

        while down_marker >= 0
            if is_spot_empty?(down_marker)
                @game_board.grid[down_marker][2] = "0"
                down_marker -= 8
            else
                if @game_board.grid[down_marker][2].color != piece.color
                    targets.append(down_marker)
                    sum += 1
                    break
                else
                    break
                end
            end
        end
        return [sum, targets]
    end

    def find_horizontal_options(piece, index)
        targets = []
        right_response = self.find_right_options(index+1, piece)
        left_response = self.find_left_options(index-1, piece)
        sum = 0
        sum += right_response[0]
        sum += left_response[0]
        if right_response.length == 2
            targets.append(right_response[1])
        end
        if left_response.length == 2
            targets.append(left_response[1])
        end
        return [sum, targets]
    end

    def find_right_options(right_marker, piece)
        targets = []
        end_of_line = false
        until end_of_line == true do
            if LEFT_EDGES.include?(right_marker) || right_marker > 63
                return [0]
            elsif is_spot_empty?(right_marker)
                @game_board.grid[right_marker][2] = "0"
                right_marker += 1
                next
            else
                if @game_board.grid[right_marker][2].color != piece.color
                    return [1, right_marker]
                else
                    return [0]
                end
            end
        end
    end

    def find_left_options(left_marker, piece)
        end_of_line = false
        until end_of_line == true do
            if RIGHT_EDGES.include?(left_marker) || left_marker < 0
                return [0]
            elsif is_spot_empty?(left_marker)
                @game_board.grid[left_marker][2] = "0"
                left_marker -= 1
                next
            else
                if @game_board.grid[left_marker][2].color != piece.color
                    return [1, left_marker]
                else
                    return [0]
                end
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
game.start_game