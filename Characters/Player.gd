extends CharacterBody2D

@export var move_speed: float = 200

func _ready():
	$AnimatedSprite2D.play("Idle")

func _physics_process(delta):
	var input = get_player_input()
	velocity = Vector2(input.x * move_speed, min(velocity.y + GameSettings.gravity, GameSettings.terminal_velocity)
	move_and_slide() # here is something wrong with collision Y velocity
	move_and_collide(velocity * delta)



func get_player_input():
	var input : Vector2
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input
