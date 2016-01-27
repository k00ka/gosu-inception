require 'gosu'
require_relative 'player'

class Ammo
attr_reader :x, :y, :ammo_img
attr_accessor :x, :y, :ammo_img
	def initialize(window)
	@window = window
	@x = 200
	@y = 300
	@ammo_img = "media/bulletz.png"
	@imagens = Gosu::Image.new(window,@ammo_img, true)
	end
	
	def draw
		imagem= @imagens
		imagem.draw_rot(@x, @y, 20, 0)
	end
end
