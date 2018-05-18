import numpy as np

label_dict = {"WK": 0, "WQ": 1, "WN": 2, "WB": 3, "WR": 4, "WP": 5,
              "BK": 6, "BQ": 7, "BN": 8, "BB": 9, "BR": 10, "BP": 11}

board_letters = {"a": 0, "b": 1, "c": 2, "d": 3,
                 "e": 4, "f": 5, "g": 6, "h": 7}


def board_init(board):
    # rook, knight, bishop, queen, king, bishop, knight, and rook
    # type, y (num), x (letter)
    board[label_dict["WP"], 1, :] = 1
    board[label_dict["BP"], 6, :] = 1
    board[label_dict["WR"], 0, 0] = 1
    board[label_dict["WN"], 0, 1] = 1
    board[label_dict["WB"], 0, 2] = 1
    board[label_dict["WQ"], 0, 3] = 1
    board[label_dict["WK"], 0, 4] = 1
    board[label_dict["WB"], 0, 5] = 1
    board[label_dict["WN"], 0, 6] = 1
    board[label_dict["WR"], 0, 7] = 1
    board[label_dict["BR"], 7, 0] = 1
    board[label_dict["BN"], 7, 1] = 1
    board[label_dict["BB"], 7, 2] = 1
    board[label_dict["BQ"], 7, 3] = 1
    board[label_dict["BK"], 7, 4] = 1
    board[label_dict["BB"], 7, 5] = 1
    board[label_dict["BN"], 7, 6] = 1
    board[label_dict["BR"], 7, 7] = 1

    return board


def update_board(board, move_pair):  # take in pairs as move
    split_move = move_pair.split(' ')

    if len(split_move) == 2:
        white = split_move[0]
        black = split_move[1]

        # white

        if len(white) == 2:  # pawn
            x = white[0]
            y = white[1]
            piece_type = "WP"

        elif len(white) == 3:  # named piece
            piece_type = "W" + white[0]
            x = white[1]
            y = white[2]

        board1 = board.flatten()

        # black

        if len(black) == 2:  # pawn
            x = black[0]
            y = black[1]
            piece_type = "BP"

        elif len(black) == 3:  # named piece
            piece_type = "B" + black[0]
            x = black[1]
            y = black[2]

        board2 = board.flatten()

        return board1, board2, board


def main():
    board = np.zeros((12, 8, 8), dtype=int)
    board = board_init(board)


if __name__ == '__main__':
    main()
