# gosu-inception
## Project for the speed sprint workshop [first presented at Toronto Ruby Hack Night, January 28, 2016]

This project, based on the Inception project by Julian Sansat, has been selected to be a part of the speed-sprint workshop.
The speed-sprint project can be found here: https://github.com/k00ka/speed-sprint.

# User Stories
1. Improve control layout + more forgiving bites before death early in the game

  Shooting those damn zombies is hard. Players should be able to shoot more comfortably. Our specs say players die after 2 bites, but players are reporting they die after only one. Players should recognize when they are bitten.

2. Portal tile allows movement to next level + remove timed level switching

  Jumping between levels uncontrollably has been a problem. Create portals between the levels and that allow a player to walk on to bring them to the next level.

3. Improve zombie pathing when near obstacles - they should not get “stuck”

  The monsters are pretty dumb. They get stuck behind walls, even a few feet away from a player. The zombies should no longer get stuck behind every wall.

4. Mini-map

  These levels are huge! Players are reporting going in circles and being lost. Create a mini-map to help them navigate each level.

Team 5
change:
1) don't die at 1 hit
2) shoot is now left alt

Other observations
- player moves by angle in
    -look at girar_direita(player.rb:118), girar_esquerda(player.rb:124)
- actual key input is in: (inception.rb ~ 698)

Team 3
change:
1. refactor map class to own file
2. added portal image to media folder
3. removed random inception
3. added portal class (is not called in program currently)
