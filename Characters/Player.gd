extends CharacterBody2D

signal change_state(state, state_id)

@export var move_speed: float = 200
@export var jump_impulse: float = 600

enum STATE {
	IDLE,
	RUN,
	JUMP,
	DOUBLE_JUMP
}

var current_state : STATE = STATE.IDLE : set = set_state, get = get_state 
var jumps : int = 0

func _physics_process(delta):
	var input = get_player_input()
	adjust_flip_direction(input)
	velocity = Vector2(input.x * move_speed, min(velocity.y + GameSettings.gravity, GameSettings.terminal_velocity))
	move_and_slide()
	velocity = get_real_velocity()
	set_anim_parameters()
	pick_next_state()

func adjust_flip_direction(input: Vector2):
	if sign(input.x) == 1:
		$AnimatedSprite2D.flip_h = false
	elif sign(input.x) == -1:
		$AnimatedSprite2D.flip_h = true
		

func set_anim_parameters():
	$AnimationTree.set("parameters/x_move/blend_position", sign(velocity.x))
	
	#todo: animation tree is still not working. jumping animation broke all
	$AnimationTree.set("parameters/y_sign/blend_amount", sign(velocity.y))
	
func pick_next_state():
	if is_on_floor():
		jumps = 0
		
		if Input.is_action_just_pressed("jump"):
			self.current_state = STATE.JUMP
		elif abs(velocity.x) > 0: # player move forward or backward
			self.current_state = STATE.RUN
		else: 
			self.current_state = STATE.IDLE 
		print(jumps)
	else:
		if Input.is_action_just_pressed("jump") and jumps < 2:
			self.current_state = STATE.DOUBLE_JUMP
			
func get_player_input():
	var input : Vector2
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input

func set_state(state):
	match(state):
		STATE.JUMP:
			jump()
		STATE.DOUBLE_JUMP:
			jump()
			$AnimationTree.set("parameters/double_jump/active", true)
	
	current_state = state
	emit_signal("change_state", STATE.keys()[state], state)

func get_state():
	return current_state

func jump():
	velocity.y = -jump_impulse
	jumps += 1
