import numpy as np

label_dict = {"wk": 0, "wq": 1, "wn": 2, "wb": 3, "wr": 4, "wp": 5,
              "bk": 6, "bq": 7, "bn": 8, "bb": 9, "br": 10, "bp": 11}
board = np.zeros((12, 8, 8), dtype=int)


def board_init():
    global board
    # rook, knight, bishop, queen, king, bishop, knight, and rook
    board[label_dict["wp"], 1, :] = 1
    board[label_dict["bp"], 6, :] = 1
    board[label_dict["wr"], 0, 0] = 1
    board[label_dict["wn"], 0, 1] = 1
    board[label_dict["wb"], 0, 2] = 1
    board[label_dict["wq"], 0, 3] = 1
    board[label_dict["wk"], 0, 4] = 1
    board[label_dict["wb"], 0, 5] = 1
    board[label_dict["wn"], 0, 6] = 1
    board[label_dict["wr"], 0, 7] = 1
    board[label_dict["br"], 7, 0] = 1
    board[label_dict["bn"], 7, 1] = 1
    board[label_dict["bb"], 7, 2] = 1
    board[label_dict["bq"], 7, 3] = 1
    board[label_dict["bk"], 7, 4] = 1
    board[label_dict["bb"], 7, 5] = 1
    board[label_dict["bn"], 7, 6] = 1
    board[label_dict["br"], 7, 7] = 1


def main():
    board_init()
    print(board)


if __name__ == '__main__':
    main()
