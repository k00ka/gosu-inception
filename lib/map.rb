class Map
	attr_reader :width, :height
	def initialize(window, filename,tipo)
		@tileset = Gosu::Image::load_tiles(window, "media/vase3.png", 32, 32, true)
		lines = File.readlines(filename).map { |line| line.chomp }
		@tipo = tipo
		@height = lines.size
		@width = lines[0].size
		if(@tipo == "urbano")
		@tiles = Array.new(@width) do |x|
		Array.new(@height) do |y|
			case lines[y][x, 1]

				when '"'
					4
				when 'c'
					3
				when 't'
					6
				when ','
					13
				when 's'
					15
				when 'o'
					25
				when 'i'
					26
				when 'u'
					27
				when 'd'
					7
				when '$'
					45
				when 'a'
					46
				when '-'
					64
				when 'e'
					60
				when 'z'
					67
				when 'x'
					84
				when 'y'
					94
				when 'p'
					118 #solido
				when '#'
					124 #solido
				when '%'
					127 #solido
				when 'q'
					135 #solido
				when 'l'
					149 #solido
				when 'w'
					152 #solido
				when 'j'
					173 #solido/arvore
				when 'k'
					174 #solido/arvore
				when 'n'
					190 #solido/arvore
				when 'm'
					191 #solido/arvore
				when 'f'
					202
				when 'g'
					203
				when 'v'
					219
				when 'b'
					220
				else
					5
				end
			end
		end
		elsif(@tipo == "deserto")
			@tiles = Array.new(@width) do |x|
			Array.new(@height) do |y|
			case lines[y][x, 1]
				when 'p'
					63 #solido
				when '.'
					7
				when '='
					5
				when '+'
					34
				when '#'
					27
				when '@'
					25
				when '&'
					142
				when '%'
					125
				when '!'
					32
				when '?'
					66
				when '$'
					15
				else
					6
				end
			end
		end
		elsif(@tipo == "inferno")
			@tiles = Array.new(@width) do |x|
			Array.new(@height) do |y|
			case lines[y][x, 1]
				when 'p'
					63 #solido
				when '@'
					88
				when '.'
					169
				when '$'
					134
				when '+'
					165
				when 'r'
					45
				when 'e'
					44
				when '%'
					164
				when 'w'
					64
				when '&'
					163
				when '#'
					168
				when 'q'
					55
				when '*'
					132
				when 't'
					47
				when '?'
					38
				else
					88
				end
			end
		end


		elsif(@tipo == "futuro")
			@tiles = Array.new(@width) do |x|
			Array.new(@height) do |y|
			case lines[y][x, 1]
				when 'p'
					155 #solido
				when '.'
					154
				when '#'
					153
				when '@'
					156
				end
			end
		end
		end

	end

	def draw(camera_x,camera_y)
		for x in ((camera_x/32) - 1).to_i .. ((camera_x/32) + 30).to_i
			for y in ((camera_y/32) - 1).to_i .. ((camera_y/32) + 19).to_i
				if(x < @width) && (y < @height)
					tile = @tiles[x][y]
					@tileset[tile].draw(x * 32, y * 32, 0)
				end
			end
		end
	end


	def solid(x, y)
		#if(x < @width) && (y < @height)
			z = @tiles[x / 32][y / 32]
			if(z == 155 || z==125 || z == 88 || z == 168 || z == 164 || z == 132 || z == 44 || z == 134 || z == 124 || z == 118 || z == 173 || z == 174 || z == 190 || z == 191 || z == 202 || z == 203 || z == 219 || z == 220 || z == 84 || z == 67 || z == 94 || z == 135 || z == 152 || z == 127 || z == 149 || z == 63 || z == 133 || z == 34 || z == 142)

				return true
			else
				return false
			end
		#else

		#end
	end

	def solid_p(x, y)
		#if(x < @width) && (y < @height)
			z = @tiles[x / 32][y / 32]
			if(z == 155 || z == 125 || z == 168 || z == 164 || z == 132 || z == 44 || z == 134 || z == 124 || z == 118 || z == 173 || z == 174 || z == 190 || z == 191 || z == 202 || z == 203 || z == 219 || z == 220 || z == 84 || z == 67 || z == 94 || z == 135 || z == 152 || z == 127 || z == 149 || z == 63 || z == 133 || z == 34 || z == 142)

				return true
			else
				return false
			end
	end

	def lava(x,y)
		z = @tiles[x / 32][y / 32]
		if(z == 88)
			return true
		else
			return false
		end
	end

end