class Car
	attr_reader :x, :y, :keys, :gasoline, :battery
	attr_accessor :x, :y, :keys, :gasoline, :battery
	def initialize(window)
		@window = window
		@x = 2562
		@y = 1500
		@angulo = 0
		@imagens = Gosu::Image.new(@window,"media/car.png", true)
		@keys = false
		@gasoline = false
		@battery = false
	end

	
	def draw
		imagem= @imagens
		imagem.draw_rot(@x, @y, 2, @angulo)
	end
	
	def move
		@y += 2
	end
end	
class Keys
	attr_reader :x, :y
	attr_accessor :x, :y
	def initialize(window, x, y)
		@window = window
		@x = x
		@y = y
		@angulo = 0
		@imagens = Gosu::Image.new(@window,"media/keys.png", true)
	end

	
	def draw
		imagem= @imagens
		imagem.draw_rot(@x, @y, 2, @angulo)
	end
	

end

class Gas
	attr_reader :x, :y
	attr_accessor :x, :y
	def initialize(window, x, y)
		@window = window
		@x = x
		@y = y
		@angulo = 0
		@imagens = Gosu::Image.new(@window,"media/gas.png", true)
	end

	
	def draw
		imagem= @imagens
		imagem.draw_rot(@x, @y, 2, @angulo)
	end
	

end

class Battery
	attr_reader :x, :y
	attr_accessor :x, :y
	def initialize(window, x, y)
		@window = window
		@x = x
		@y = y
		@angulo = 0
		@imagens = Gosu::Image.new(@window,"media/battery.png", true)
	end

	
	def draw
		imagem= @imagens
		imagem.draw_rot(@x, @y, 2, @angulo)
	end
	

end

class Msg
	def initialize(window, x, y)
	@font = Gosu::Font.new(window, Gosu::default_font_name, 20)
	@x = x
	@y = y
	end
	
	def draw
		@font.draw("Find the keys and gasoline", @x, @y, 10, factor_x = 1, factor_y = 1, color = 0xffff0000, mode = :default)
	end
end

class Msg2
	def initialize(window, x, y)
	@font = Gosu::Font.new(window, Gosu::default_font_name, 20)
	@x = x
	@y = y
	end
	
	def draw
		@font.draw("Find the battery", @x, @y, 10, factor_x = 1, factor_y = 1, color = 0xffff0000, mode = :default)
	end
end
