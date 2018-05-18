import chess.pgn

pgn = open("/Users/varunshijo/IRT-CSE712/Top10/anand.pgn")
games = []

while True:
    boards = []
    game = chess.pgn.read_game(pgn)
    board = game.board()
    boards.append(board)

    for move in game.main_line():
        board.push(move)
        boards.append(board)
    games.append(boards)
    print(boards)

print(games)
