require 'gosu'
require_relative 'map'
require_relative 'player'
require_relative 'bullet'
require_relative 'zombie'
require_relative 'car'

class Inception < Gosu::Window
attr_reader :map,:delay_cut

def initialize(invincible_mode = false)
	super(800, 600, false)
    self.caption = "Game"
	@last_time = Gosu::milliseconds / 1000.0
	@map = Map.new(self, "media/map.txt", "urbano")
	@mapa = 'urbano'
	@player = Player.new(self)
	@hit = Gosu::Sample.new(self, "media/zm_hit.wav")
	@empty = Gosu::Sample.new(self, "media/w_empty.wav")
	@reload_sound = Gosu::Sample.new(self, "media/w_clipin.wav")
	@wall = Gosu::Sample.new(self, "media/ricmetal2.wav")
	@die = Gosu::Sample.new(self, "media/die3.wav")
	@win = Gosu::Sample.new(self, "media/40.wav")
	@unstop = Gosu::Sample.new(self, "media/unstoppable.wav")
	@low = Gosu::Sample.new(self, "media/low.wav")
	@pick = Gosu::Sample.new(self, "media/click2.wav")
	@atk = Gosu::Sample.new(self, "media/zm_attack2.wav")
	@kills = 0
	@bullets = []
	@zombies = []
	@delay_shoot = true
	@delay_pause = true
	@delay_bite = true
	@delay_layer = false
	@last_layer = 0
	@last_pause = 0
	@last_disparo = 0
	@last_hit = 0
	@last_bite = 0
	@last_corte = 0
	@delay_cut = true
	@colisao = false
	@camera_x = @camera_y = 0
	@font2 = Gosu::Font.new(self, Gosu::default_font_name, 50)
	@gera_zombies = true
	@game_state = 'starting'
	@background_image = Gosu::Image.new(self, "media/menuback.png", true)
	@background_image2 = Gosu::Image.new(self, "media/dead.png", true)
	@background_image3 = Gosu::Image.new(self, "media/win.png", true)
	@blood = []
	@ammo = []
	@clips = []
	@key = []
	@gera_key = false
	@gas = []
	@gera_gas = false
	@battery = []
	@gera_battery = false
	@car = Car.new(self)
	@msg = Msg.new(self,@car.x,@car.y)
	@msg2 = Msg2.new(self,@car.x,@car.y)
	@ammo_img = "media/ammo.png"
	@invincible_mode = invincible_mode
	for a in 1..@player.ammo
		@ammo << Gosu::Image.new(self, @ammo_img, false)
	end
	@shotgun = []
end

def update_delta
  current_time = Gosu::milliseconds / 1000.0
  @delta = [current_time - @last_time, 0.25].min
  @last_time = current_time
end


def draw
	if(@game_state == 'starting')
		@background_image.draw(0, 0, 0)
	elsif(@game_state == 'ended')
		@background_image2.draw_rot(400, 300, 0,0)
	elsif(@game_state == 'win')
		@background_image3.draw_rot(400, 300, 0,0)
	else
	if(@game_state == 'paused')
	@font2.draw("PAUSED", 290, 200, 10, factor_x = 1, factor_y = 1, color = 0xffff0000, mode = :default)
	end
	translate(-@camera_x, -@camera_y) do
	  @map.draw(@camera_x,@camera_y)
      @player.draw(@mapa)
	  if(@mapa == "urbano")
	  @car.draw
	  end
	  if(Gosu::distance(@car.x, @car.y, @player.x, @player.y) < 90 && (@car.keys == false || @car.gasoline == false) && @mapa == "urbano")
		@msg.draw
	  elsif (Gosu::distance(@car.x, @car.y, @player.x, @player.y) < 90 && (@car.keys == true || @car.gasoline == true && @car.battery == false) && @mapa == "urbano")
		@msg2.draw
	  end
	  @ammo.each_with_index do |item, index|
		item.draw(@camera_x + (index*15),@camera_y,30)
	  end
	  @zombies.each { |zombie| zombie.draw }
	  @blood.each { |blood| blood.draw }
	  @key.each { |key| key.draw }
	  @gas.each { |gas| gas.draw }
	  @shotgun.each { |shotgun| shotgun.draw }
	  @battery.each { |battery| battery.draw }
	  #@wapons.each { |weapons| weapons.draw }
	for bullet in @bullets do
		bullet.draw
		@bullets.reject! do |bullet|
		Gosu::distance(@player.x, @player.y, bullet.x, bullet.y) > 400
		end
	end
	for clip in @clips do
		clip.draw
	end
	end
	end
end

def win
	if(Gosu::distance(@car.x, @car.y, @player.x, @player.y) < 90 && @car.keys == true && @car.gasoline == true && @car.battery == true && @mapa == "urbano")
		@win.play
		@ammo = []
		@gera_zombies = false
		@zombies = []
		@key = []
		@gas = []
		@battery = []
		@blood = []
		@game_state = 'win'
	end
end

def blood(x,y,angulo)
	@blood.push(Blood.new(self,x,y,angulo))
end

def mordido
	return if @invincible_mode
	if(@delay_bite == true)
		@atk.play
		self.blood(@player.x,@player.y,@player.angulo)
		@delay_bite = false
		@last_bite = @last_time
		@player.alive = false
		@player.hits += 1
		if(@player.hits > 2)
		@die.play
		self.morre
		end
	end
end



def morre
	@ammo = []
	@gera_zombies = false
	@zombies = []
	@key = []
	@gas = []
	@battery = []
	@blood = []
	@game_state = 'ended'
end

def reinicia
	@player = Player.new(self)
	@car.keys = false
	@car.gasoline = false
	@car.battery = false
	@gera_zombies = true
	@gera_gas = false
	@gera_key = false
	@gera_battery = false
	@kills = 0
	@last_layer = 0
	for a in 1..@player.ammo
		@ammo << Gosu::Image.new(self, "media/ammo.png", false)
	end
	@game_state = 'starting'
end

#def battery
	#if((Gosu::distance(@car.x, @car.y, @player.x, @player.y) < 90) && (@car.keys == true && @car.gasoline == true && @car.battery == false))
		#@gera_battery = true
	#end
#end

def colisao_bala(x,y,angulo)
	future_x = x
	future_y = y
	future_x += Gosu::offset_x(angulo, 5)
	future_y += Gosu::offset_y(angulo, 5)
	@bullets.reject! do |bullet|
	 if @map.solid_p(future_x, future_y) == true then
		@wall.play
	end
	end
	for zombie in @zombies do
			if(zombie.alive == true)
			@bullets.reject! do |bullet|
			Gosu::distance(zombie.x, zombie.y, bullet.x, bullet.y) < 20
			end

				if(Gosu::distance(zombie.x, zombie.y, x, y) < 20)
					@hit.play
					zombie.damage += @player.weapon_damage
					@last_hit = @last_time
				end
			end
	end
end
def reload(clips)
	@reload_sound.play
	@player.ammo = clips
	@ammo = []
	for a in 1..@player.ammo
		if(@player.weapon == "p228")
		@ammo << Gosu::Image.new(self, "media/ammo.png", false)
		elsif(@player.weapon == "shotgun")
		@ammo << Gosu::Image.new(self, "media/shell.png", false)
		end
	end
end
def colisao_player(player_x,player_y,direcao)
	future_x = @player.x
	future_y = @player.y
	if(direcao == true && @player.veiculo == "pe")
		future_x += Gosu::offset_x(@player.angulo, 25)
		future_y += Gosu::offset_y(@player.angulo, 25)
	elsif(direcao == false && @player.veiculo == "pe")
		future_x -= Gosu::offset_x(@player.angulo, 25)
		future_y -= Gosu::offset_y(@player.angulo, 25)
	elsif(direcao == true && @player.veiculo == "car")
		future_x += Gosu::offset_x(@player.angulo, 70)
		future_y += Gosu::offset_y(@player.angulo, 70)
	elsif(direcao == false && @player.veiculo == "car")
		future_x -= Gosu::offset_x(@player.angulo, 70)
		future_y -= Gosu::offset_y(@player.angulo, 70)
	end
	if(@map.solid_p(future_x, future_y) == true)
		return true
	else
		return false
	end
end

def colisao_zombie(future_x,future_y)
	if(@map.solid(future_x, future_y) == true)
		return true
	else
		return false
	end
end

def inception
	if(@delay_layer == true)
		@delay_layer = false
		@last_layer = @last_time
		if(@mapa == 'urbano' )
			@mapa = 'deserto'
			@player.x = 1000
			@player.y = 1500
			@map = Map.new(self, "media/mapa_deserto.txt", "deserto")
			@zombies = []
			@clips = []
			@shotgun = []
			@gera_key = true
		elsif(@mapa == 'deserto')
			@mapa = 'futuro'
			@gera_battery = true
			@player.x = 1700
			@player.y = 1600
			@map = Map.new(self, "media/mapa_futuro.txt", "futuro")
			@zombies = []
			@key = []
			@clips = []
			@shotgun = []
		elsif(@mapa == 'futuro')
			@mapa = 'inferno'
			@gera_gas = true
			@player.x = 1200
			@player.y =1800
			@map = Map.new(self, "media/mapa_inferno.txt", "inferno")
			@zombies = []
			@battery = []
			@clips = []
			@shotgun = []
		elsif(@mapa == 'inferno')
			@mapa = 'urbano'
			@gas = []
			@player.x = 1300
			@player.y = 600
			@map = Map.new(self, "media/map.txt", "urbano")
			@zombies = []
			@clips = []
			@shotgun = []
		end
	end
end

def update
	self.update_delta
if ( button_down?(Gosu::Button::KbR) && (@game_state == 'ended' || @game_state == 'win')) then
		self.reinicia
end
if (@game_state == 'starting' ) then
			if (button_down?(Gosu::Button::KbS)) then
				@game_state = 'playing'
			end
end
if ( button_down?(Gosu::Button::KbP) && @game_state != 'starting')
	if(@delay_pause == true)
		if(@game_state == 'playing')
			@game_state = 'paused'
		else
			@game_state = 'playing'
		end
	@delay_pause = false
	@last_pause = @last_time
	end
end

if(@last_time > @last_pause + 0.2)
	@delay_pause = true
end

if(@game_state == 'playing')
	if(@last_time > @last_bite + 0.4)
		@delay_bite = true
	end
	if(@last_time > @last_layer + 20)
		@delay_layer = true
	end
	@camera_x = [[@player.x - 320, 0].max, @map.width * 50 - 640].min
    @camera_y = [[@player.y - 240, 0].max, @map.height * 50 - 480].min
	if(@gera_zombies == true)
		while(@zombies.size < 40)
			randx = (rand * 3200)
      randy = ((rand * 2680)+20)
			if(@map.solid(randx,randy) == false && Gosu::distance(randx, randy, @player.x, @player.y) > 200)
				if(@mapa == 'urbano')
				@zombies.push(Zombie.new(self,0,true,false,randx,randy,'urbano'))
				elsif(@mapa == 'deserto')
				@zombies.push(Zombie.new(self,0,true,false,randx,randy,'deserto'))
				elsif(@mapa == 'inferno')
				@zombies.push(Zombie.new(self,0,true,false,randx,randy,'inferno'))
				elsif(@mapa == 'futuro')
				@zombies.push(Zombie.new(self,0,true,false,randx,randy,'futuro'))
				end
			end
		end
	end
	@zombies.each { |zombie| zombie.vida(zombie) }
	@zombies.each { |zombie| zombie.move(@player.x,@player.y,@player.veiculo,@player.vel_x,@player.vel_y) }
	for i in @bullets
		i.move
		colisao_bala(i.x,i.y,i.angulo)
	end
	if(@clips.size < 4)
		randx = (rand * 3200)
		randy = ((rand * 2680)+20)
		if(@map.solid(randx,randy) == false && Gosu::distance(randx, randy, @player.x, @player.y) > 400)
			@clips.push(Clip.new(self,randx,randy))
		end
	end
	@clips.reject! do |clip|
		if Gosu::distance(clip.x, clip.y, @player.x, @player.y) < 25 then
			@player.weapon = 'p228'
			reload(13)
		end
	end
	if(@shotgun.size < 4)
		randx = (rand * 3200)
		randy = ((rand * 2680)+20)
		if(@map.solid(randx,randy) == false && Gosu::distance(randx, randy, @player.x, @player.y) > 400)
			@shotgun.push(Shotgun.new(self,randx,randy))
		end
	end
	@shotgun.reject! do |shotgun|
		if Gosu::distance(shotgun.x, shotgun.y, @player.x, @player.y) < 20 then
			@player.weapon = "shotgun"
			reload(7)
		end
	end

	if(@gera_key == true)
		randx = 200#(rand * 3200)
		randy = 200#((rand * 2680)+20)
		#if(@map.solid(randx,randy) == false && Gosu::distance(randx, randy, @player.x, @player.y) > 700)
			@key.push(Keys.new(self,randx,randy))
			@gera_key = false
		#end
	end
	@key.reject! do |key|
		if Gosu::distance(key.x, key.y, @player.x, @player.y) < 30 then
			@pick.play
			@car.keys = true
		end
	end
	if(@gera_gas == true)
		randx = 1300#(rand * 3200)
		randy = 1300#((rand * 2680)+20)
		#if(@map.solid(randx,randy) == false && Gosu::distance(randx, randy, @player.x, @player.y) > 700)
			@gas.push(Gas.new(self,randx,randy))#lembrar
			@gera_gas = false
		#end
	end
	@gas.reject! do |gas|
		if Gosu::distance(gas.x, gas.y, @player.x, @player.y) < 30 then
			@pick.play
			@car.gasoline = true
		end
	end
	if(@gera_battery == true && @battery.size < 1 && @car.battery == false)
		randx = 400#(rand * 3200)
		randy = 1600#((rand * 2680)+20)
		#if(@map.solid(randx,randy) == false && Gosu::distance(randx, randy, @player.x, @player.y) > 700)
			@battery.push(Battery.new(self,randx,randy))
			@gera_battery = false
		#end
	end
	@battery.reject! do |battery|
		if Gosu::distance(battery.x, battery.y, @player.x, @player.y) < 30 then
			@pick.play
			@car.battery = true
		end
	end
	@blood.reject! do |b|
		b.cur_image == b.blood[5]
	end
	@clips.reject! do |c|
		Gosu::distance(@player.x, @player.y, c.x, c.y) > 2000
	end
	#deleta zombies mortos
	if(@last_time > @last_hit + 0.4)
	@zombies.reject! do |zombie|
			if zombie.alive == false then
				@kills += 1
			end
	end
	end
	@player.parado(@mapa)
	if ( button_down?(Gosu::Button::KbRight) ) then
		@player.girar_direita
	end

	if ( button_down?(Gosu::Button::KbLeft) ) then
		@player.girar_esquerda
	end

	if ( button_down?(Gosu::Button::KbUp) && !(button_down?(Gosu::Button::KbSpace))) then
		if(colisao_player(@player.x,@player.y,true) == false)
			@player.mover_frente
			@player.updateImg(@mapa)
		end
	end

	if ( button_down?(Gosu::Button::KbDown) && !(button_down?(Gosu::Button::KbSpace))) then
		if(colisao_player(@player.x,@player.y,false) == false)
		@player.mover_tras
		@player.updateImg(@mapa)
		end
	end

	if ( button_down?(Gosu::Button::KbSpace))then
		@player.mirar(@mapa)
	end
	#teste car
	if ( button_down?(Gosu::Button::KbT))then
		#@player.veiculo = "car"
	end

	if ( button_down?(Gosu::Button::KbR))then


		#@player.veiculo = "pe"
	end



	if ( button_down?(Gosu::Button::KbLeftAlt) && button_down?(Gosu::Button::KbSpace))then
		if(@delay_shoot == true && @player.alive == true && @player.veiculo == "pe" && @player.weapon != "machete")
			if(@player.ammo > 0)
				@player.atirar
				@bullets.push(Bullet.new(self,@player.x,@player.y,@player.angulo))
				@ammo.pop
			else
				@empty.play
			end
			@delay_shoot = false
			@last_disparo = @last_time
		elsif(@delay_shoot == true && @player.alive == true && @player.veiculo == "pe" && @player.weapon == "machete")
			@player.atirar
			@delay_shoot = false
			@last_disparo = @last_time
		end
	end


	if(@last_time > @last_disparo + @player.weapon_delay)
		@delay_shoot = true
	end
	@player.current_weapon
	win
	@player.atrito
	if(@kills >= 5)
		@unstop.play
		@kills = 0
	end
	if(@delay_layer == true)
		#self.inception
		@delay_layer = false
	end
	if(@mapa == 'inferno')
		if(@map.lava(@player.x, @player.y) == true)
			@die.play
			self.morre
		end
	end

end

end
end
