#############################################################
# Tutorial: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/03.coding_the_player.html
#############################################################

extends Area2D

"""
This defines a custom signal called "hit" that we will have our player emit (send out) when it 
collides with an enemy.
"""
signal hit

#Using the export keyword on the first variable speed allows us to set its value in the Inspector. 
@export var speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

""" 
The _ready() function is called when a node enters the scene tree, which is a good time to 
find the size of the game window:
"""
func _ready():
	screen_size = get_viewport_rect().size
	#hide()

"""
_process() is called every frame, so we'll use it to update elements of our game, which we expect 
will change often. For the player, we need to do the following:

- Check for input.
- Move in the given direction.
- Play the appropriate animation.
"""
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.

	if Input.is_action_pressed("move_right"):
		velocity.x += 100
	if Input.is_action_pressed("move_left"):
		velocity.x -= 100
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	""""
	Now that the player can move, we need to change which animation the AnimatedSprite2D is playing 
	based on its direction. We have the "walk" animation, which shows the player walking to the right. 
	This animation should be flipped horizontally using the flip_h property for left movement. 
	We also have the "up" animation, which should be flipped vertically with flip_v for downward movement. 
	"""
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

"""
This signal will be emitted when a body contacts the player.
"""
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit() # will trigger the game_over() method inside main.gd script
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
