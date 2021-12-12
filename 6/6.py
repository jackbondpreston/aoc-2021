day_fish = [0] * 9

with open("input.txt") as f:
    contents = f.read()
    for fish in contents.split(","):
        fish = int(fish)
        day_fish[fish] += 1
    
print(day_fish)

days = 256
for i in range(0, days):
    zeros = day_fish[0]
    day_fish = day_fish[1:] + [0]

    day_fish[6] += zeros
    day_fish[8] += zeros

print(sum(day_fish))