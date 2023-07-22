extends Area2D

signal removed

@export var height = 100
@export var vertical_speed = 100
@export var limit_left = 0
@export var limit_right = 1440
@export var y_offset = 0.0
@export var freq = 2

var player = null

func _ready() -> void:
	$AnimationPlayer.play("default")
	$AnimatedSprite2D.play("default")
	$AnimationPlayer.speed_scale = freq
	height *= freq
	vertical_speed = randi_range(0, 10) * 50
	height = randf_range(0, 10)
	freq = randf_range(0.5, 2)

func _process(delta: float) -> void:
	position.y += y_offset * height
	position.x += vertical_speed * delta

	if position.x > limit_right+100 and vertical_speed > 0:
		vertical_speed *= -1
	elif position.x < limit_left-100 and vertical_speed < 0:
		vertical_speed *= -1

func _on_body_entered(body: Node2D) -> void:
	if not body.flying:
		body.kill()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if player == null:queue_free()
	if global_position.y > player.global_position.y:
		emit_signal("removed")
		queue_free()
