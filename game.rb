require_relative 'lib/inception'

invincible_mode = ARGV[0] == "true"
game = Inception.new invincible_mode
game.show
