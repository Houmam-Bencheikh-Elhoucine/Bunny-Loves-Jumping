extends Area2D

signal removed
signal removed_wingman
@export var acc = 100.0
@export var max_speed = 150.0


var player = null
var target = null
var acc_vect = Vector2(1, 0)
var velocity_vect = Vector2.ZERO
var gave_up = false

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	if target != null and not gave_up:
		acc_vect = -(global_position - target.global_position).normalized() * acc
		velocity_vect += acc_vect * delta
		velocity_vect = velocity_vect.limit_length(max_speed)
		max_speed += delta * 10
		acc += delta * 10
	position += velocity_vect * delta

func _on_body_entered(body: Node2D) -> void:
	if not body.flying:
		body.kill()



func _on_player_detector_body_entered(body: Node2D) -> void:
	if not gave_up and target == null:
		target = body
		$Timer.start()

func _on_timer_timeout() -> void:
	gave_up = true
	target = null



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if gave_up or target == null:
		emit_signal("removed_wingman")
		emit_signal("removed")
		queue_free()
