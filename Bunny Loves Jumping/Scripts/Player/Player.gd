extends CharacterBody2D

# Signals
signal killed


# Exported variables
@export var MAX_SPEED = 1000.0
@export var JUMP_IMPULSE = 1500.0
@export var ACCELERATION = 25.0
@export var FRICTION = 0.05
@export var GRAVITY: int = 2500.0
@export var FLYING_SPEED = 1000.0
@export var SPEED_TO_ZERO = 50

# Variables
var dead: bool = false
var flying: bool = false

# Children
@onready var sprite = $AnimatedSprite2D
@onready var particles = $CPUParticles2D
@onready var init_y_pos = global_position.y

var gender = "boy"

# Overridden functions
func _physics_process(delta: float) -> void:
	var direction = get_input()
	var acc = Vector2.ZERO
	acc.y = GRAVITY * delta
	acc.x = direction * ACCELERATION

	velocity += acc
	velocity.x -= velocity.x * FRICTION * .5
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	if velocity.y >= 0 and flying: 
		flying = false

	if velocity.x < SPEED_TO_ZERO and velocity.x > -SPEED_TO_ZERO and acc.x == 0:
		velocity.x = 0
	
	if (init_y_pos-global_position.y) > GameManager.max_height:
		GameManager.score += int((init_y_pos - global_position.y - GameManager.max_height)/10)
		GameManager.max_height = init_y_pos-global_position.y
	move_and_slide()
	animate()


# Other functions 
func animate():
	particles.emitting = false
	if dead: 
		sprite.play(gender+"dead")
		return
	if flying: 
		sprite.play(gender+"flying")
		return
	if is_on_floor():
		if velocity.x == 0:
			sprite.play(gender+"idle")
		else:
			sprite.play(gender+"walk")
			particles.emitting = true
	else:
		sprite.play(gender+"jump")

func get_input():
	if dead:
		velocity.x = 0 
		return 0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_IMPULSE
	if Input.is_action_just_released("jump") and velocity.y < 0 and not flying:
		velocity.y *= 0.5

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	return Input.get_axis("move_left", "move_right")

func kill():
	velocity.y = -JUMP_IMPULSE/2
	dead = true
	emit_signal("killed")
	collision_layer = 0
	collision_mask = 0
	$VisibleOnScreenNotifier2D.visible = false


# Signal callbacks
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if dead and velocity.y > 0:
		velocity.y = 0
	if velocity.y > 0:
		kill()

func update_character():
	gender = GameManager.player_gender
