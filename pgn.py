# import pandas as pd

# match_data = pd.

with open("/Users/varunshijo/CSE712/Top10/Anand.pgn") as f:
    read_file = f.read()

read_file = read_file.split(":")


read_file = read_file[1:]  # use subset of these values as dataframe rows 

metadata = []
moves = []


for game in read_file:
    meta, move, _ = game.split("\n\n")

    metadata.append(meta)
    moves.append(move)

# for move in moves:
#     splitmove = move.split('.')
#     print(splitmove)
#     secondsplit = splitmove.split(' ')
#     for doublesplit in secondsplit:
#         if len(doublesplit) >= 2:
#             white = doublesplit[0]
#             black = doublesplit[1]


print(moves[0])