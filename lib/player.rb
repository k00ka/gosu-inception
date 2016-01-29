require 'gosu'
require_relative 'bullet'

class Player
  attr_reader :x, :y, :angulo, :vel_x, :vel_y, :alive, :hits, :weapon, :bang, :som_tiro, :weapon_delay, :weapon_damage, :veiculo, :player, :game_state
  attr_accessor :x, :y, :angulo, :vel_x, :vel_y, :ammo, :alive, :hits, :weapon, :som_tiro, :weapon_delay, :weapon_damage, :veiculo, :game_state

  def initialize(window)
    @window = window
    @veiculo = "pe"
    @game_state = "normal"
    @player = Gosu::Image::load_tiles(@window, "media/armado_5.png", 50, 50, false)
    @player_arab = Gosu::Image::load_tiles(@window, "media/armado_arabe.png", 50, 50, false)
    @cur_image = @player[0]
    @cur_image2 = @player_arab[0]
    @x = 1300
    @y = @window.height/2
    @angulo = 0.0
    @vel_x = 0
    @vel_y = 0
    @weapon = "p228"
    @weapon_delay = 1
    @weapon_damage = 1
    @weapon_img = "media/m3.bmp"
    @weapon_image = Gosu::Image.new(@window, @weapon_img, true)
    @car_img = Gosu::Image.new(@window, "media/car.png", true)
    @cortar_img = [@player[9], @player[10], @player[11], @player[3]]
    @ammo = 13
    @alive = true
    @hits = 0
    @som_tiro = "media/p228.wav"
    @bang = Gosu::Sample.new(window, @som_tiro)
  end

  def draw(mapa)
    if (mapa == 'deserto' && self.game_state == "normal")
      image = @cur_image2
      image.draw_rot(@x, @y, 5, @angulo)
    elsif (mapa != 'deserto' && self.game_state == "normal")
      image = @cur_image
      image.draw_rot(@x, @y, 5, @angulo)
    end
  end


  def parado(mapa)
    if (mapa == 'deserto' && self.game_state == "normal")
      @cur_image2 = @player_arab[0]
    elsif (mapa != 'deserto' && self.game_state == "normal")
      @cur_image = @player[0]
    end
  end


  def updateImg(mapa)
    if (self.alive == true && mapa == 'deserto')
      @cur_image2 = @player_arab[Gosu::milliseconds / 100 % 6]
    elsif (self.alive == true && mapa != 'deserto')
      @cur_image = @player[Gosu::milliseconds / 100 % 6]
    end
  end

  def mirar(mapa)
    if (self.alive == true && mapa == 'deserto')
      if (self.weapon == "p228")
        @cur_image2 = @player_arab[6]
      elsif (self.weapon == "shotgun" && self.veiculo == "pe")
        @cur_image2 = @player_arab[8]
      elsif (self.weapon == "machete" && self.veiculo == "pe")
        @cur_image2 = @player_arab[9]
      end
    elsif (self.alive == true && mapa != 'deserto')
      if (self.weapon == "p228")
        @cur_image = @player[6]
      elsif (self.weapon == "shotgun" && self.veiculo == "pe")
        @cur_image = @player[8]
      elsif (self.weapon == "machete" && self.veiculo == "pe")
        @cur_image = @player[9]
      end
    end
  end

  def atirar
    if (self.weapon != "machete")
      @bang.play
      self.ammo -= 1
    else
      @cur_image = @player[11]
    end
  end

  def cortar
    @game_state = "cortando"
  end

  def mover_frente
    if (self.alive == true && self.veiculo == "pe")
      @vel_x = Gosu::offset_x(@angulo, 2.7)
      @vel_y = Gosu::offset_y(@angulo, 2.7)
      @x += @vel_x
      @y += @vel_y
    elsif (self.alive == true && self.veiculo == "car")
      @vel_x += Gosu::offset_x(@angulo, 0.5)
      @vel_y += Gosu::offset_y(@angulo, 0.5)
    end
  end

  def mover_tras
    if (self.alive == true)
      @x -= Gosu::offset_x(@angulo, 2.0)
      @y -= Gosu::offset_y(@angulo, 2.0)
    elsif (self.alive == true && self.veiculo == "car")
      @vel_x -= Gosu::offset_x(@angulo, 0.2)
      @vel_y -= Gosu::offset_y(@angulo, 0.2)
    end
  end

  def girar_direita
    if (self.alive == true)
      @angulo += 4.0
    end
  end

  def girar_esquerda
    if (self.alive == true)
      @angulo -= 4.0
    end
  end

  def atrito
    if (self.veiculo == "car" && @window.colisao_player(self.x, self.y, true) == false)
      self.x += self.vel_x
      self.y += self.vel_y
      self.vel_x *= 0.95
      self.vel_y *= 0.95
    end
  end

  def current_weapon
    if (self.weapon == "p228")
      self.som_tiro = "media/p228.wav"
      self.weapon_delay = 0.4
      self.weapon_damage = 1
    elsif (self.weapon == "shotgun")
      self.som_tiro = "media/m3.wav"
      self.weapon_delay = 0.8
      self.weapon_damage = 3
    end
    @bang = Gosu::Sample.new(@window, @som_tiro)
  end

end

class Blood
  attr_reader :x, :y, :cur_image, :blood
  attr_accessor :x, :y, :cur_image, :blood

  def initialize(window, x, y, angulo)
    @window = window
    @x = x
    @y = y
    @angulo = angulo
    @blood = Gosu::Image::load_tiles(@window, "media/blood.png", 100, 100, true)
    @cur_image = @blood[0]
  end

  def draw
    @cur_image = @blood[Gosu::milliseconds / 50 % @blood.size]
    image = @cur_image
    image.draw_rot(@x, @y, 10, @angulo)
  end

end
