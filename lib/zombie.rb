require 'gosu'
require_relative 'player'

class Zombie
attr_reader :x,:y,:angulo, :damage, :alive
attr_accessor :x, :y, :angulo, :damage, :alive

def initialize(window,damage,alive,dead,x,y,mapa)
	@window = window
  @zombie = @@zombie ||= Gosu::Image::load_tiles(@window, "media/mostro.png", 40, 40, false)
  @mummy = @@mummy ||= Gosu::Image::load_tiles(@window, "media/mummy.png", 40, 40, false)
  @demo = @@demo ||= Gosu::Image::load_tiles(@window, "media/marisa.png", 40, 40, false)
  @robot = @@robot ||= Gosu::Image::load_tiles(@window, "media/robot.png", 40, 40, false)
  @zombie_dead = @@zombie_dead ||= Gosu::Image::load_tiles(@window, "media/zomb_dead.png", 33, 69, false)
  @mummy_dead = @@mummy_dead ||= Gosu::Image::load_tiles(@window, "media/dead_mummy.png", 33, 69, false)
  @demo_dead = @@demo_dead ||= Gosu::Image::load_tiles(@window, "media/dead_marisa.png", 33, 69, false)
  @robot_dead = @@robot_dead ||= Gosu::Image::load_tiles(@window, "media/robot_dead.png", 33, 69, false)
    @cur_image = @zombie[0]
	@cur_image2 = @mummy[0]
	@cur_image3 = @demo[0]
	@cur_image4 = @robot[0]
  @die = @@die ||= Gosu::Sample.new(@window, "media/zm_die.wav")
	@x = x
	@y = y
    @angulo = 0
	@damage = damage
	@alive = alive
	@mapa = mapa
	if(@mapa == 'inferno')
	@vel = rand(1.3...1.6)
	else
	@vel = rand(0.7...1.1)
	end
	@dead = dead
	
 end
  
def draw
	if(@mapa == 'urbano')
		image = @cur_image
		image.draw_rot(@x, @y, 2, @angulo)
	elsif(@mapa == 'deserto')
		image = @cur_image2
		image.draw_rot(@x, @y, 2, @angulo)
	elsif(@mapa == 'inferno')
		image = @cur_image3
		image.draw_rot(@x, @y, 2, @angulo)	
	elsif(@mapa == 'futuro')
		image = @cur_image4
		image.draw_rot(@x, @y, 2, @angulo)		
	end
end

def update_image
	if(@mapa == 'urbano')
	@cur_image = @zombie[Gosu::milliseconds / 80 % 6]
	elsif(@mapa == 'deserto')
	@cur_image2 = @mummy[Gosu::milliseconds / 80 % 6]
	elsif(@mapa == 'inferno')
	@cur_image3 = @demo[Gosu::milliseconds / 80 % 6]
	elsif(@mapa == 'futuro')
	@cur_image4 = @robot[Gosu::milliseconds / 80 % 6]
	end
end


def move(player_x,player_y,veiculo,vel_x,vel_y)
if(self.alive ==true && Gosu::distance(self.x, self.y, player_x, player_y) < 600)
	self.update_image
	if (player_x >= self.x)
		x = player_x - self.x
	else
		x = self.x - player_x
	end	
	
	if (player_y >= self.y)
		y = player_y - self.y
	else
		y = self.y - player_y
	end	
	tangente = y/x
	arcotangente = Math.atan(tangente) * 57.2957795
	if (player_x <= self.x && player_y <= self.y)
	angulo1 = arcotangente + 90
	elsif(player_x > self.x && player_y < self.y)
	angulo1 = -arcotangente - 90
	elsif(player_x < self.x && player_y > self.y)
	angulo1 = -arcotangente - 270
	else
	angulo1 = arcotangente + 270
	end
	future_x = self.x
	future_y = self.y
	if(self.x < player_x)
		future_x += @vel
	elsif(self.x > player_x)
		future_x -= @vel
	end
	
	if(self.y < player_y)
		future_y += @vel
	elsif(self.y > player_y)
		future_y -= @vel
	end
	self.angulo = angulo1
	if(@window.colisao_zombie(future_x,future_y) == false)
		self.x = future_x
		self.y = future_y
	else	
	if(@window.colisao_zombie(future_x + @vel,future_y) == false)
		self.x += @vel
		self.y = future_y
	elsif(@window.colisao_zombie(future_x + @vel,future_y + @vel) == false)	
		self.x += @vel
		self.y += @vel
	elsif(@window.colisao_zombie(future_x,future_y + @vel) == false)	
		self.x = future_x
		self.y += @vel
	elsif(@window.colisao_zombie(future_x - @vel,future_y + @vel) == false)	
		self.x -= @vel
		self.y += @vel
	elsif(@window.colisao_zombie(future_x - @vel,future_y) == false)	
		self.x -= @vel
		self.y = future_y
	elsif(@window.colisao_zombie(future_x - @vel,future_y - @vel) == false)	
		self.x -= @vel
		self.y -= @vel
	elsif(@window.colisao_zombie(future_x,future_y - @vel) == false)	
		self.x = future_x
		self.y -= @vel	
	end
	end
	if (veiculo == "pe" && Gosu::distance(self.x, self.y, player_x, player_y) < 20) then
		@window.mordido
	elsif(veiculo == "car" && Gosu::distance(self.x, self.y, player_x, player_y) < 50)
		self.x += Gosu::offset_x(self.angulo, 10.0)
		self.y += Gosu::offset_y(self.angulo, 10.0)
		if(vel_x > 0)
			self.damage += 0.2 * vel_x
		elsif(vel_x < 0)
			self.damage += 0.2 * (-1*vel_x)	
		end	
	end
end	
end

def vida(zombie)
	if(zombie.damage >= 3)
		zombie.alive = false
		zombie.morre
		@window.blood(self.x,self.y,self.angulo)
	end
end 

def morre
	if(@dead == false)
		@die.play
		if(@mapa == 'urbano')
		@cur_image = @zombie_dead[1]
		elsif(@mapa == 'deserto')
		@cur_image2 = @mummy_dead[1]
		elsif(@mapa == 'inferno')
		@cur_image3 = @demo_dead[1]
		elsif(@mapa == 'futuro')
		@cur_image4 = @robot_dead[1]
		end
		@dead = true
	end	
end 

end
