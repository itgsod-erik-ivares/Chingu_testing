require 'chingu'

class Game < Chingu::Window

	def initialize
		super
		self.input = {esc: :exit}
		Level.create
		5.times {Meteor.create}
		Player.create
	end
	 def update
	 	super
	 	Laser.each_bounding_circle_collision(Meteor) do |laser, target|
       		laser.destroy
       		target.destroy
       	end
     end

end

class Player < Chingu::GameObject
	has_traits :velocity, :timer
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
		@speed = 10
		@angle = 0
		@animation = Chingu::Animation.new(:file => "flame_48x48.png")
		@animation.frame_names = { still: => 0..1, :up => 2..5, :fire => 6..7}
	end

	 def update
	 	self.velocity_x *= 0.95
	 	self.velocity_y *= 0.95

	 	@x %= 800
	 	@y %= 600
	 end


	def left
		@angle -= 4.5
	end

	def right
		@angle += 4.5
	end

	def up
		self.velocity_y += Gosu::offset_y(@angle, 0.5) 
		self.velocity_x += Gosu::offset_x(@angle, 0.5) 
		@frame_name = :up
	end

	def down
		self.velocity_y -= Gosu::offset_y(@angle, 0.5) 
		self.velocity_x -= Gosu::offset_x(@angle, 0.5) 
	end

	def fire
		Laser.create(x: @x, y: @y, angle: @angle)
	end
end



class Laser < Chingu::GameObject

	has_traits :velocity, :collision_detection, :bounding_circle, :timer

	def setup
		@image = Gosu::Image["shot.png"]
		self.velocity_y += Gosu::offset_y(@angle, 20)
		self.velocity_x += Gosu::offset_x(@angle, 20) 
		after(1001) {self.destroy}
	end
	def update
		@x %= 800
		@y %= 600
	end
end


class Level < Chingu::GameObject
	def setup
		@x = 400
		@y = 300
		@image = Gosu::Image["space.png"]
	end

end

class Meteor < Chingu::GameObject

	has_traits :collision_detection, :bounding_circle, :velocity

	def setup
		@image = Gosu::Image["meteor.png"]
		@angle = rand(359)
		self.velocity_y += Gosu::offset_y(@angle, rand(1...6))
		self.velocity_x += Gosu::offset_x(@angle, rand(1...6)) 
	end

	def update
		@x %= 800
		@y %= 600
	end


end

Game.new.show