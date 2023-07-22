extends Area2D

@export var FORCE = 3500


func _on_body_entered(body: Node2D) -> void:
	if body.velocity.y > 0:
		body.velocity.y = -FORCE
		body.flying = true
		$AnimatedSprite2D.play("new_animation")
