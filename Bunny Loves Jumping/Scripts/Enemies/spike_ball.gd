extends Area2D

signal removed

var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")



func _on_body_entered(body: Node2D) -> void:
	if not body.flying:
		body.kill()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if player == null: queue_free()
	if player.global_position.y < global_position.y:
		emit_signal("removed")
		queue_free()
