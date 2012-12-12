# require 'rubygems' rescue nil
require 'chingu'
#include Gosu
#include Chingu

class Game < Chingu::Window

	def initialize
		super
		self.input = {esc: :exit}	
		#retrofy
		Level.create
		5.times {Meteor.create}
		2.times {Astroid.create}
		Player.create
	end
	def update
	 	super	
			self.caption = "Astroid game! Made myself! fps = #{self.fps}"
	 	Laser.each_bounding_circle_collision(Meteor) do |laser, target|
       		laser.destroy
       		target.destroy
       	end
       	 Meteor.each_bounding_circle_collision(Player) do |meteor, player|
       	 	GO.new
       	 end
	 	Astroid.each_bounding_circle_collision(Meteor) do |laser, target|
       		laser.destroy
       		@hp = -1
       	end
    end

end

	# game over skylten när man dör
# class Go < Chingu::GameObject
# 	@x = 400
# 	@y = 300
# 	@image = Gosu::Image["gameover.png"]
# end

class Player < Chingu::GameObject
	has_traits :velocity, :collision_detection, :timer
#:collision_detection, :bounding_circle,
	#meta construktur
	def setup
		super
		@x = 400
		@y = 300
		#@image = Gosu::Image["Ship.png"]
		 self.input = {
		 	holding_left: :left,
		 	holding_right: :right,
		 	holding_up: :up,
		 	holding_down: :down,
		 	space: :fire
		 }
		@speed = 10
		@angle = 0
		@animation = Chingu::Animation.new(:file => "flame_48x48.bmp")
		@animation.frame_names = { :still =>0..1, :up =>2..5, :fire =>6..7}
# :still =>0..1, :fire =>6..7, :up =>2..5
		@frame_name = :still
		@last_x, @last_y = @x, @y
	end

	def left
		@angle -= 4.5
		@frame_name = :up
	end

	def right
		@angle += 4.5
		@frame_name = :up
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
		@frame_name = :fire
	end

	def update
	 	@frame_name = :still if @x == @last_x && @y == @last_y

	 	@last_x, @last_y = @x, @y
	 	self.velocity_x *= 0.95
	 	self.velocity_y *= 0.95

	 	@x %= 800
	 	@y %= 600
	end
end



class Laser < Chingu::GameObject

	has_traits :velocity, :collision_detection, :bounding_circle, :timer

	def setup
		@image = Gosu::Image["shot.png"]
		self.velocity_y += Gosu::offset_y(@angle, 20)
		self.velocity_x += Gosu::offset_x(@angle, 20) 
		after(750) {self.destroy}
	end
	def update
	end
end


class Level < Chingu::GameObject
	def setup
		@x = 400
		@y = 300
		@image = Gosu::Image["space.png"]
	end

end

class Astroid < Chingu::GameObject

	has_traits :collision_detection, :bounding_circle, :velocity

	@hp = 2

	def setup
		@image = Gosu::Image["crystal.png"]
		@angle = rand(359)
		self.velocity_y += Gosu::offset_y(@angle, rand(1...6))
		self.velocity_x += Gosu::offset_x(@angle, rand(1...6))

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