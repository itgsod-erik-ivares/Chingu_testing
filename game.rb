require 'chingu'

class Game < Chingu::Window

	def initialize
		super
		self.input = {esc: :exit}
		Player.create
	end
end

class Player < Chingu::GameObject

	#meta construktur
	def setup
		@x = 400
		@y = 300
		@image = Gosu::Image["Ship.png"]
		self.input = {
			holding_left: :left,
			holding_right: :right,
			holding_up: :up,
			holding_down: :down,
			space: :fire
		}

	end

	def left
		@x -= 5
	end

	def right
		@x += 5
	end

	def up
		@y -= 5
	end

	def down
		@y += 5
	end

	def fire
		Laser.create(x: @x, y: @y)
	end

end

class Laser < Chingu::GameObject

	has_traits :velocity

	def setup
		@image = Gosu::Image["shot.png"]
		self.velocity_y = -10
	end


end

Game.new.show