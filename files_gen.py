import os

matches = []

filepath = "/Users/varunshijo/IRT-CSE712/Top10/all.pgn"


# for subdir, dirs, files in os.walk(filepath):
#     for file in files:
with open(filepath) as file:
    read_file = file.read()

    read_file = read_file.split(":")
    read_file = read_file[1:]

    for game in read_file:
        matches.append(game)

count = 0

for game in matches:
    with open("/Users/varunshijo/IRT-CSE712/Top10/"+str(count)+".pgn",'w') as f:
        f.write(game)
    count+=1
